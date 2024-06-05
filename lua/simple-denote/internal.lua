local M = {}

--- Trim whitespace on either end of string
function M.trim(str)
   local from = str:match"^%s*()"
   return from > #str and "" or str:match(".*%S", from)
end

--- Make lowercase, remove special chars, remove extraneous spaces
function M.plain_format(string)
  if not string then return "" end
  string = string:gsub("[^%w%s]","")
  string = string:lower()
  string = M.trim(string)
  string = string:gsub("%s+"," ")
  return string
end

---@param string string
---@param char delimiter that replaces spaces (- for titles, _ for tags)
--- Format the title/tags string of a Denote filename
function M.format_denote_string(string, char)
  string = M.plain_format(string)
  if string == "" then return "" end
  string = char .. char .. string:gsub("%s", char)
  return string
end

---@param title string heading text
---@param ext string file extension
---Set the first line to title, including the appropriate heading char
function M.set_heading(title, ext)
  local prefix = ""
  if ext == "md" then
    prefix = "# "
  elseif ext == "org" or ext == "norg" then
    prefix = "* "
  end
  vim.api.nvim_buf_set_lines(0, 0, 1, false, {prefix .. title})
end

---@param new_filename string
---@param old_filename string
---Save new file, delete old file
function M.replace_file(old_filename, new_filename)
  if old_filename ~= new_filename then
    vim.cmd('saveas ' .. new_filename)
    vim.cmd('silent !rm ' .. old_filename)
  end
end

---@param options table
---@param title string
---@param tags table|nil
---Edit a new note with a Denote filename
function M.note(options, title, tags)
  title = M.trim(title)
  local og_title = title
  tags = M.format_denote_string(tags, "_")
  title = M.format_denote_string(title, "-")
  local file = options.dir .. os.date("%Y%m%dT%H%M%S")
  file = file .. title .. tags .. "." .. options.ext
  vim.cmd("edit " .. file)
  if options.add_heading and og_title ~= "" then
    M.set_heading(og_title, options.ext)
    vim.cmd("norm! 2o")
  end
  vim.cmd("startinsert")
end

---@param options table
---@param filename string
---@param title string
--- Retitles the filename and changes the first heading of the note
function M.retitle(options, filename, title)
  local new_filename = filename:match("^(.-%d%d%d%d%d%d%d%dT%d%d%d%d%d%d).*")
  local tags = filename:match(".-(__.*)%..*")
  if new_filename == nil then
    error("This file doesn't look like it has a Denote-style name")
  end
  title = M.trim(title)
  if options.retitle_heading and title ~= "" then
    local first_char = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:sub(1, 1)
    if (first_char == "#" and options.ext == "md") or 
       (first_char == "*" and (options.ext == "org" or options.ext == "norg")) then
      M.set_heading(title, options.ext)
    end
  end
  title = M.format_denote_string(title, "-")
  new_filename = new_filename .. title .. (tags or "") .. "." .. options.ext
  M.replace_file(filename, new_filename)
end

---@param options table
---@param filename string
---@param new_tags table
---Replaces the tags in filename
function M.retag(options, filename, tags)
  local new_filename = filename:match("^(.*)__.*$")
  if new_filename == nil then
    new_filename = filename:match("^(.*)%..*$")
  end
  tags = M.format_denote_string(tags, "_")
  new_filename = new_filename .. tags .. "." .. options.ext
  M.replace_file(filename, new_filename)
end

return M
