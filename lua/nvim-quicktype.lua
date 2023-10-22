-- main module file
local module = require("nvim-quicktype.module")

---@class Config
local config = {
  js = "js",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.generate_type = function()
  module.generate_type(M.config)
end
return M
