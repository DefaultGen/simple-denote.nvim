local M = {}

function M.splitspace(str)
	local chunks = {}
	for substring in str:gmatch("%S+") do
		table.insert(chunks, #chunks, substring)
	end
	return chunks
end

function M.splitstring(str, delim)
	local items = {}
	local fulldelim = nil
	if delim == "." or delim == "-" then
		fulldelim = "%" .. delim
	else
		fulldelim = delim
	end
	print("fulldelim: ", fulldelim)
	str = str .. delim
	for w in str:gmatch("(.-)" .. fulldelim) do
		items[#items + 1] = w
	end
	return items
end

return M
