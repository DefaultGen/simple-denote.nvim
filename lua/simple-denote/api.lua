local M = {}

local internal = require("simple-denote.internal")

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
function M.title(options, filename, title)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not title then
    vim.ui.input({ prompt = "New title: " }, function(input)
      title = input
    end)
  end
  internal.title(options, filename, title)
end

---@param options table
---@param filename string|nil
---@param tags table|nil
function M.tag(options, filename, tags)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not tags then
    vim.ui.input({ prompt = "New tags: " }, function(input)
      tags = input
    end)
  end
  internal.tag(options, filename, tags)
end

---@param options table
---@param filename string|nil
---@param sig string
function M.signature(options, filename, sig)
  filename = filename or vim.fn.expand("%")
  if not sig then
    vim.ui.input({ prompt = "Signature: " }, function(input)
      sig = input
    end)
  end
  internal.signature(options, filename, sig)
end

return M
