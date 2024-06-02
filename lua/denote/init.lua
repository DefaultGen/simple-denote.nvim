local M = {}

local cmd = require("denote.cmd")
local config = require("denote.config")

---@param options? table user configuration
function M.setup(options)
  config.options = vim.tbl_deep_extend("force", config.defaults, options or {})
  cmd.load_cmd(config.options)
end

return M
