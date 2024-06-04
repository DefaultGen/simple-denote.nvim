local M = {}

local internal = require("simple-denote.internal")

function M.splitspace(str)
  local chunks = {}
  for substring in str:gmatch("%S+") do
    table.insert(chunks, #chunks, substring)
  end
  return chunks
end

---@param options table
---@param name string|nil
---@param tags table|nil
function M.note(options, name, tags)
  if not name then
    vim.ui.input({ prompt = "Note title: " }, function(input)
      name = input
    end)
  end
  if not tags then
    vim.ui.input({ prompt = "Tags: " }, function(input)
      tags = input
    end)
  end
  internal.note(options, name, tags)
end

---@param options table
---@param filename string|nil
---@param new_title string|nil
function M.retitle(options, filename, title)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not title then
    vim.ui.input({ prompt = "New title: " }, function(input)
      title = input
    end)
  end
  internal.retitle(options, filename, title)
end

---@param options table
---@param filename string|nil
---@param new_tags table|nil
function M.retag(options, filename, tags)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not tags then
    vim.ui.input({ prompt = "New tags: " }, function(input)
      tags = input
    end)
  end
  internal.retag(options, filename, tags)
end

return M
