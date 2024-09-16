-- main module file
local module = require("nvim-quicktype.module")

---@class FileTypeConfig
---@field lang string
---@field top_level_name string
---@field additional_options table

---@class GlobalConfig
---@field output_file string
---@field src_lang string
---@field no_combine_classes boolean
---@field all_properties_optional boolean
---@field alphabetize_properties boolean
---@field telemetry string
---@field debug_dir string|nil

---@class Config
local config = {
  global = {
    quicktype_cmd = "quicktype",
    output_file = nil,
    src_lang = "json",
    no_combine_classes = false,
    all_properties_optional = true,
    alphabetize_properties = false,
    telemetry = "disable",
    debug_dir = nil,
  },
  filetypes = {
    typescript = { lang = "ts", additional_options = {
      ["just-types"] = true,
      ["prefer-unions"] = true,
    } },
    python = { lang = "py", additional_options = {
      ["just-types"] = true,
      ["nice-property-names"] = true,
      ["python-version"] = "3.7",
    } },
    java = { lang = "java", additional_options = {
      ["just-types"] = true,
    } },
    go = { lang = "go", additional_options = {
      ["just-types"] = true,
    } },
    rust = { lang = "rs", additional_options = {
      ["no-leading-comments"] = true,
      ["density"] = "dense",
    }},
    cs = { lang = "cs", additional_options = {
      ["density"] = "dense",
      ["features"] = "just-types",
    } },
    swift = { lang = "swift", additional_options = {
      ["density"] = "dense",
      ["just-types"] = true,
    } },
    elixir = { lang = "elixir", additional_options = {
      ["just-types"] = true,
    } },
    kotlin = { lang = "kotlin", additional_options = {
      ["framework"] = "just-types",
    } },
  },
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- You can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  if args then
    if args.global then
      M.config.global = vim.tbl_deep_extend("force", M.config.global, args.global)
    end
    if args.filetypes then
      for ft, ft_config in pairs(args.filetypes) do
        if M.config.filetypes[ft] then
          M.config.filetypes[ft] = vim.tbl_deep_extend("force", M.config.filetypes[ft], ft_config)
        else
          M.config.filetypes[ft] = ft_config
        end
      end
    end
  end
end

M.generate_type = function()
  module.generate_type(M.config)
end

return M
