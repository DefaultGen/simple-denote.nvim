local M = {}
local api = require("denote.api")
local cmd = require("denote.cmd")

---@param config DenoteConfig
function M.setup(config)
	cmd.load_cmd()
	if config then
		internal.config = config
	end
end

return M
