local M = {}

---@param str string
---Trim whitespace on either end of string
function M.trim(str)
   local from = str:match"^%s*()"
   return from > #str and "" or str:match(".*%S", from)
end

---@param str string
---Make lowercase, remove special chars, remove extraneous spaces
function M.plain_format(str)
  str = str:gsub("[^%w%s]","")
  str = str:lower()
  str = M.trim(str)
  str = str:gsub("%s+"," ")
  return str
end

---@param str string
---@param char delimiter that replaces spaces (- for titles, _ for tags, = for sigs)
---Format the title/tags/sig string of a Denote filename
function M.format_denote_string(str, char)
  str = M.plain_format(str)
  if str == "" then return "" end
  str = char .. char .. str:gsub("%s", char)
  return str
end

---@param title string heading text
---@param ext string file extension
---Set the first line to title if it's an empty buffer or the first line is a heading
function M.set_heading(options, title)
  if title == "" then return end
  local first_char = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]:sub(1, 1)
  if first_char == "" or first_char == options.heading_char then
    local prefix = options.heading_char
    if prefix ~= "" then prefix = prefix .. " " end
    vim.api.nvim_buf_set_lines(0, 0, 1, false, {prefix .. title})
  end
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
---@param tags string
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
    M.set_heading(options, og_title)
    vim.cmd("norm! 2o")
  end
  vim.cmd("startinsert")
end

---@param options table
---@param filename string
---@param title string
--- Retitles the filename and changes the first heading of the note
function M.title(options, filename, title)
  local prefix = filename:match("^(.-%d%d%d%d%d%d%d%dT%d%d%d%d%d%d).*")
  if not prefix then
    error("This doesn't look like a Denote filename")
  end
  local sig = filename:match(".-(==[^%-%_%.]*)")
  local tags = filename:match(".-(__.*)%..*")
  if not tags then tags = "" end
  if not sig then sig = "" end
  title = M.trim(title)
  if options.retitle_heading then
    M.set_heading(options, title)
  end
  title = M.format_denote_string(title, "-")
  local new_filename = prefix .. sig .. title .. tags .. "." .. options.ext
  M.replace_file(filename, new_filename)
end

---@param options table
---@param filename string
---@param tags string
---Replaces the __tags in filename
function M.tag(options, filename, tags)
  local prefix = filename:match("^(.*)__.*$")
  if not prefix then
    prefix = filename:match("^(.*)%..-$")
  end
  if not prefix:match("%d%d%d%d%d%d%d%dT%d%d%d%d%d%d") then
    error("This doesn't look like a Denote filename")
  end
  tags = M.format_denote_string(tags, "_")
  local new_filename = prefix .. tags .. "." .. options.ext
  M.replace_file(filename, new_filename)
end

---@param options table
---@param filename string
---@param sig string
---Add/change the ==signature in the filename
function M.signature(options, filename, sig)
  local prefix, suffix = filename:match("^(.-%d%d%d%d%d%d%d%dT%d%d%d%d%d%d)(.*)")
  if not prefix then
    error("This doesn't look like a Denote filename")
  end
  suffix = suffix:gsub("==[^%-%_%.]*", "")
  sig = M.format_denote_string(sig, "=")
  local new_filename = prefix .. sig .. suffix
  M.replace_file(filename, new_filename)
end

return M
