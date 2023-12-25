local M = {}
local config = require("denote.config")
local util = require("denote.util")

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
---@param tags table|nil
---@param func function
function M.search(date, name, tags, func)
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
			matcher = matcher .. "%d%d"
		end
		if date.day then
			matcher = matcher .. date.day
		else
			matcher = matcher .. "%d%d"
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

	if tags then
		local items_copy = items
		items = {}
		for _, item in pairs(items_copy) do
			local item_tags_pre = M.get_tags(item)
			local item_tags = {}
			for _, i in pairs(item_tags_pre) do
				item_tags[i] = 0
			end
			local good = true
			for _, tag in pairs(tags) do
				if item_tags[tag] == nil then
					good = false
				end
			end
			if good then
				items[#items + 1] = item
			end
		end
	end

	vim.ui.select(items, {
		prompt = "Select note",
	}, func)

	return true
end

---@param filename string
---@return table
function M.get_tags(filename)
	local tags = {}
	local name = util.splitstring(filename, ".")[1]
	for _, s in pairs(util.splitstring(util.splitstring(name, config.filename.name_sep)[3], config.filename.tag_sep)) do
		tags[#tags + 1] = s
	end
	return tags
end

return M
