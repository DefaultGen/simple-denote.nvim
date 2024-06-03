local M = {}
local util = require("simple-denote.util")

---@param tags table
--- Create a_tag_string from tags table
function M.make_tag_str(tags)
  if not tags then return "" end
  local tags_str = ""
  for i, tag in pairs(tags) do
    tag = util.plain_format(tag)
    tags_str = tags_str .. tag
    if i < #tags then
      tags_str = tags_str .. "_"
    end
  end
  return "__" .. tags_str:lower()
end

---@param title heading text
---@param ext file extension
function M.set_heading(title, ext)
  prefix = ""
  if ext == "md" then
    prefix = "# "
  elseif ext == "org" or ext == "norg" then
    prefix = "* "
  end
  vim.api.nvim_buf_set_lines(0, 0, 1, false, {prefix .. title})
end

---@param options table
---@param name string
---@param tags table|nil
--- Opens your note
function M.note(options, name, tags)
  name = util.trim(name)
  local og_name = name
  local tags_str = M.make_tag_str(tags)
  name = util.plain_format(name)
  local file = options.dir .. os.date("%Y%m%dT%H%M%S")
  if name ~= "" then
    file = file .. "--"
  end
  file = file .. name .. tags_str .. "." .. options.ext
  vim.cmd("e " .. file)
  if options.add_heading and og_name ~= "" then
    M.set_heading(og_name, options.ext)
    vim.cmd("norm! o")
  end
  vim.cmd("startinsert")
end

---@param options table
---@param filename string
---@param new_title string
--- Retitles the filename and changes the first heading of the note
function M.retitle(options, filename, new_title)
  local new_filename = filename:match("^(.*%d%d%d%d%d%d%d%dT%d%d%d%d%d%d).-")
  local tags_str = filename:match(".*(__.*)%..*")
  if new_filename == nil then
    error("This file doesn't look like it has a Denote-style name")
  end
  new_title = util.trim(new_title)
  if options.retitle_heading and new_title ~= "" then
    local first_char = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:sub(1, 1)
    if (first_char == "#" and options.ext == "md") or 
       (first_char == "*" and (options.ext == "org" or options.ext == "norg")) then
      M.set_heading(new_title, options.ext)
    end
  end
  new_title = util.plain_format(new_title)
  if new_title ~= "" then
    new_title = "--" .. new_title
  end
  new_filename = new_filename .. new_title .. (tags_str or "") .. "." .. options.ext
  if filename ~= new_filename then
    vim.cmd('saveas ' .. new_filename)
    vim.cmd('silent !rm ' .. filename)
  end
end

---@param options table
---@param filename string
---@param new_tags table
---Replaces the tags in filename with the tags in new_tags
function M.retag(options, filename, new_tags)
  local new_filename = filename:match("^(.*)__.*$")
  if new_filename == nil then
    new_filename = filename:match("^(.*)%..*$")
  end
  local tags_str = M.make_tag_str(new_tags)
  if tags_str ~= "" then
    new_filename = new_filename .. tags_str
  end
  new_filename = new_filename .. "." .. options.ext
  if filename ~= new_filename then
    vim.cmd('saveas ' .. new_filename)
    vim.cmd('silent !rm ' .. filename)
  end
end

return M
