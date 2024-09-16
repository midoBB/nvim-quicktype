local M = {}

local function get_ft_config(config, ft)
  if ft == "typescriptreact" then
    ft = "typescript"
  end

  local ft_config = config.filetypes[ft]

  if not ft_config then
    vim.notify("Nvim-Quicktype: Unsupported file type: " .. ft, vim.log.levels.WARN)
    return nil
  end

  return ft_config
end

local function build_command(config, ft_config, json_str, top_level_type_name)
  local quicktype_cmd = config.global.quicktype_cmd or "quicktype"
  local cmd = "cat << EoF | " .. quicktype_cmd

  -- Add global options
  if config.global.output_file then
    cmd = cmd .. " -o " .. config.global.output_file
  end
  cmd = cmd .. " --src-lang " .. config.global.src_lang
  if config.global.no_combine_classes then
    cmd = cmd .. " --no-combine-classes"
  end
  if config.global.all_properties_optional then
    cmd = cmd .. " --all-properties-optional"
  end
  if config.global.alphabetize_properties then
    cmd = cmd .. " --alphabetize-properties"
  end
  cmd = cmd .. " --telemetry " .. config.global.telemetry

  -- Add language-specific options
  cmd = cmd .. " -l " .. ft_config.lang
  cmd = cmd .. " -t " .. top_level_type_name

  -- Add additional options
  for option, value in pairs(ft_config.additional_options) do
    cmd = cmd .. " --" .. option
    if type(value) ~= "boolean" then
      cmd = cmd .. " " .. tostring(value)
    end
  end

  if config.global.debug_dir then
    cmd = cmd .. " 2>" .. config.global.debug_dir .. "/err.log"
  else
    cmd = cmd .. " 2>/dev/null"
  end
  -- Add the JSON input and error redirection
  cmd = cmd .. " \n" .. json_str .. "\nEoF"

  return cmd
end

local function write_debug_info(debug_dir, command)
  if debug_dir then
    local debug_file = debug_dir .. "/quicktype_debug_" .. os.time() .. ".log"
    local file = io.open(debug_file, "w")
    if file then
      file:write("Executed command:\n" .. command .. "\n")
      file:close()
      print("Debug info written to: " .. debug_file)
    else
      print("Failed to write debug info to: " .. debug_file)
    end
  end
end

local function is_valid_json(str)
  -- Attempt to decode the string as JSON
  local success, _ = pcall(vim.json.decode, str)
  return success
end

local function get_json_str_from_reg()
  -- Try to get JSON from the "+" (system) register first
  local json_str = vim.fn.getreg("+")
  if json_str == "" then
    -- Try to get JSON from the '"' (unnamed) register
    json_str = vim.fn.getreg('"')
    if json_str ~= "" then
      return json_str
    end
  end
  --  Fallback to the "0" register
  return vim.fn.getreg("0")
end

M.generate_type = function(config)
  -- Get the JSON string from the register
  local json_str = get_json_str_from_reg()
  -- Check if the string is valid JSON
  if not is_valid_json(json_str) then
    vim.notify("The clipboard content is not valid JSON.", vim.log.levels.ERROR)
    return
  end
  -- Get the current filetype
  local ft = vim.bo.ft

  -- Get the configuration for the current filetype
  local ft_config = get_ft_config(config, ft)
  -- If ft_config is nil, it means the file type is not supported
  if not ft_config then
    return
  end
  -- Prompt the user for the top-level type name.
  local top_level_type_name = vim.fn.input("Enter the top-level type name: ")

  -- Build the command
  local command = build_command(config, ft_config, json_str, top_level_type_name)
  -- Write debug info if debug_dir is set
  write_debug_info(config.global.debug_dir, command)
  -- Execute the command
  local result = vim.fn.systemlist(command)
  -- Check if the command was successful
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Error generating types. Exit code: " .. vim.v.shell_error)
  else
    -- Insert the result into the current buffer
    vim.api.nvim_buf_set_lines(0, vim.fn.line("."), vim.fn.line("."), false, result)
  end
end

return M
