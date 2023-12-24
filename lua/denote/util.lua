local M = {}

function M.splitspace(str)
	local chunks = {}
	for substring in str:gmatch("%S+") do
		table.insert(chunks, #chunks, substring)
	end
	return chunks
end

return M
