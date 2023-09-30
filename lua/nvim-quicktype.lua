-- plugin.lua

local M = {}

function M.generate_type()
  -- Get the JSON from the clipboard.
  local json = vim.fn.getreg("+")
  -- Prompt the user for the top-level type name.
  local top_level_type_name = vim.fn.input("Enter the top-level type name: ")
  local targetLanguage = vim.bo.ft

  local command = "cat << EoF | quicktype -l "
    .. targetLanguage
    .. " -t "
    .. top_level_type_name
    .. " --just-types --all-properties-optional \n"
  command = command .. json .. "\n"
  command = command .. "EoF"
  local success, result = pcall(vim.fn.system, command)
  if not success then
    vim.api.nvim_err_writeln("Error generating types.")
  else
    local lines = vim.fn.split(result, "\n")
    vim.api.nvim_buf_set_lines(0, vim.fn.line("."), vim.fn.line("."), false, lines)
    --[[ local pos = vim.fn.getcurpos()[2]
    vim.fn.append(pos, result)
    vim.cmd("silent normal! j=2j")
    vim.fn.setpos(".", pos) ]]
  end
end

return M
