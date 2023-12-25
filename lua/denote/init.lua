local M = {
	api = require("denote.api"),
	cmd = require("denote.cmd"),
}

---@param config DenoteConfig
function M.setup(config)
	M.cmd.load_cmd()
	if config then
		M.config = config
	end
end

return M
