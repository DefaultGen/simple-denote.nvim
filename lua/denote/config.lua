---@class DenoteConfigFilename
---@field ext string defaults to "norg"
---@field date_sep string defaults to "_"
---@field name_sep string defaults to "-"
---@field tag_sep string defaults to "="

---@class DenoteConfigVault
---@field dir string defaults to "~/.denote/"

---@class DenoteConfig
---@field filename DenoteConfigFilename
---@field vault DenoteConfigVault

---@type DenoteConfig
local M = {
	filename = {
		ext = "norg",
		date_sep = "_",
		name_sep = "-",
		tag_sep = "=",
	},
	vault = {
		dir = "~/.denote/",
	},
}

return M
