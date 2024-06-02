local M = {}

local internal = require("denote.internal")
local util = require("denote.util")

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
      if input ~= "" and input then
        tags = util.splitspace(input)
      end
    end)
  end
  internal.note(options, name, tags)
end

---@param options table
---@param filename string|nil
---@param new_title string|nil
function M.retitle(options, filename, new_title)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not new_title then
    vim.ui.input({ prompt = "New title: " }, function(input)
      new_title = input
    end)
  end
  internal.retitle(options, filename, new_title)
end

---@param options table
---@param filename string|nil
---@param new_tags table|nil
function M.retag(options, filename, new_tags)
  if not filename then
    filename = vim.fn.expand("%")
  end
  if not new_tags then
    vim.ui.input({ prompt = "New tags: " }, function(input)
      if input ~= "" and input then
        new_tags = util.splitspace(input)
      end
    end)
  end
  internal.retag(options, filename, new_tags)
end

return M
