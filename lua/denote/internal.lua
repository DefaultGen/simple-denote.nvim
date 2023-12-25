local M = {}
local config = require("denote.config")

---@class DenoteDate
---@field year string
---@field month string
---@field day string

---@param name string
---@param tags table|nil
---@return string filename format of files in denote.nvim
function M.file(name, tags)
	local file = ""

	local date = tostring(os.date("%Y%m%d"))

	local tags_str = ""

	if tags then
		for i, tag in pairs(tags) do
			tags_str = tags_str .. tag
			if i < #tags then
				tags_str = tags_str .. config.filename.tag_sep
			end
		end
	end

	file = date .. config.filename.date_sep .. config.filename.date_sep .. name
	if tags then
		file = file .. config.filename.name_sep .. config.filename.name_sep .. tags_str
	end

	return file .. "." .. config.filename.ext
end

---@param name string
---@param tags table|nil
--- Opens your note
function M.note(name, tags)
	local filename = config.vault.dir .. M.file(name, tags)

	-- Echo template

	vim.cmd("!mkdir -p " .. config.vault.dir)
	vim.cmd("e " .. filename)
end

---@param date DenoteDate|nil
---@param name string|nil
---@param func function
function M.search(date, name, func)
	local items = {}
	local matcher = ""

	if date then
		if date.year then
			matcher = date.year
		else
			matcher = "%d%d%d%d"
		end
		if date.month then
			matcher = matcher .. date.month
		else
			matcher = "%d%d"
		end
		if date.day then
			matcher = matcher .. date.day
		else
			matcher = "%d%d"
		end

		matcher = matcher .. config.filename.date_sep .. config.filename.date_sep
	else
		matcher = "%d+" .. config.filename.date_sep .. config.filename.date_sep
	end

	if name then
		matcher = matcher .. name
	else
		matcher = matcher .. ".+"
	end

	-- matcher = matcher .. config.filename.name_sep .. "?" .. M.config.filename.name_sep .. "?" .. ".-"

	for file in io.popen("ls " .. config.vault.dir):lines() do
		local matched = file:match(matcher)

		if matched then
			print("file " .. file)
			items[#items + 1] = file
		end
	end

	if not items or #items == 0 then
		return nil
	end

	vim.ui.select(items, {
		prompt = "Select note",
		-- format_item = function(item)
		-- 	return "" .. item
		-- end,
	}, func)

	return true
end

return M
