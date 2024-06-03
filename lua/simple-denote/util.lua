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
  str = str .. delim
  for w in str:gmatch("(.-)" .. fulldelim) do
    items[#items + 1] = w
  end
  return items
end

--- Trim whitespace on either end of string
function M.trim(str)
   local from = str:match"^%s*()"
   return from > #str and "" or str:match(".*%S", from)
end

--- Remove special chars, make lowercase, spaces to dashes
function M.plain_format(str)
  str = str:lower()
  str = str:gsub("[^%w%s]","")
  str = M.trim(str)
  str = str:gsub("%s+","-")
  return str
end

return M
