local M = {}

---@param options table
---@param name string
---@param tags table|nil
--- Opens your note
function M.note(options, name, tags)
  local path = options.dir
  local file = ""
  local date = os.date("%Y%m%dT%H%M%S")
  local tags_str = ""
  name = name:gsub("^%s*(.-)%s*$", "%1")
  name = name:gsub("[^%w%s]","")
  name = name:gsub("%s","-")
  if tags then
    for i, tag in pairs(tags) do
      tag = tag:gsub("[^%w%s]","")
      tags_str = tags_str .. tag
      if i < #tags then
        tags_str = tags_str .. "_"
      end
    end
  end
  file = date .. "--" .. name:lower()
  if tags_str ~= "" then
    file = file .. "__" .. tags_str:lower()
  end
  path = path .. file .. "." .. options.ext
  vim.cmd("e " .. path)
end

---@param options table
---@param filename string
---@param new_title string
--- Retitles the filename and changes the first heading of the note
function M.retitle(options, filename, new_title)
  local new_filename = filename:match("^(.*%d%d%d%d%d%d%d%dT%d%d%d%d%d%d).*")
  local tags = filename:match(".*(__.*)%..*")
  if new_filename == nil then
    error("Doesn't look like a Denote filename")
  end
  new_title = new_title:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace

  -- Replace first line with new heading
  if options.new_heading_on_retitle == true and new_title ~= "" then
    local first_char = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:sub(1, 1)
    if (first_char == "#" and options.ext == "md") or 
       (first_char == "*" and (options.ext == "org" or options.ext == "norg")) then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, {first_char .. " " .. new_title})
    end
  end
  new_title = new_title:lower()
  new_title = new_title:gsub("[^%w%s]","")
  new_title = new_title:gsub("%s","-")
  if new_title ~= "" then
    new_title = "--" .. new_title
  end
  new_filename = new_filename .. new_title .. (tags or "") .. "." .. options.ext
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
  local tags_str = ""
  local new_filename = filename:match("^(.*)__.*$")
  if new_filename == nil then
    new_filename = filename:match("^(.*)%..*$")
  end
  if new_tags then
    for i, tag in pairs(new_tags) do
      tag = tag:gsub("[^%w%s]","")
      tags_str = tags_str .. tag
      if i < #new_tags then
        tags_str = tags_str .. "_"
      end
    end
  end
  if tags_str ~= "" then
    new_filename = new_filename .. "__" .. tags_str:lower()
  end
  new_filename = new_filename .. "." .. options.ext
  if filename ~= new_filename then
    vim.cmd('saveas ' .. new_filename)
    vim.cmd('silent !rm ' .. filename)
  end
end

return M
