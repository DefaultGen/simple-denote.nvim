local M = {}

local cmd = require("simple-denote.cmd")
local config = require("simple-denote.config")

---@param options? table user configuration
function M.setup(options)
  config.options = vim.tbl_deep_extend("force", config.defaults, options or {})
  if config.options.dir:sub(-1) ~= "/" then
    config.options.dir = config.options.dir .. "/"
  end
  cmd.load_cmd(config.options)
end

return M
