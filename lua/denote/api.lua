local M = {}
local internal = require("denote.internal")
local util = require("denote.util")
local config = require("denote.config")

---@param name string|nil
---@param tags table|nil
function M.note(name, tags)
	if not name then
		vim.ui.input({ prompt = "Note name: " }, function(input)
			name = input
		end)
	end

	if not tags then
		vim.ui.input({ prompt = "Enter tags: " }, function(input)
			if input ~= "" and input then
				tags = util.splitspace(input)
			end
		end)
	end

	if name == "" then
		error("Didn't specify name")
	end

	internal.note(name, tags)
end

---@param date DenoteDate|nil
---@param name string|nil
function M.search(date, name)
	if not date then
		vim.ui.input({ prompt = "Date: " }, function(input)
			local split = util.splitspace(input)
			if split[0] then
				date = {}
				date.year = split[0]
				if split[1] then
					date.month = split[1]
					if split[2] then
						date.day = split[2]
					end
				end
			end
		end)
	end

	if not name then
		vim.ui.input({ prompt = "Name: " }, function(input)
			name = input
		end)
	end

	local status = internal.search(date, name, function(input)
		if input then
			vim.cmd("e " .. config.vault.dir .. "/" .. input)
		end
	end)

	if not status then
		print("Error opening file")
	end
end

return M
