local M = {}

function M.search(options)
  local width = vim.o.columns - 8
  local height = vim.o.lines - 8

  vim.api.nvim_open_win(
    vim.api.nvim_create_buf(false, true),
      true,
      {
        relative = 'editor',
        style = 'minimal',
        border = 'rounded',
        noautocmd = true,
        width = width,
        height = height,
        col = math.min((vim.o.columns - width) / 2),
        row = math.min((vim.o.lines - height) / 2 - 1),
      }
    )
    local file = vim.fn.tempname()
    -- This feels like the wrong way to call a script from a relative path
    local lua_file_path = debug.getinfo(1, "S").source:sub(2)
    local lua_file_dir = vim.fn.fnamemodify(lua_file_path, ":h")
    local script_path = lua_file_dir .. "/scripts/search.sh"
    if not script_path then
        error("Script not found")
    end
    vim.api.nvim_command('startinsert')
    vim.fn.termopen(script_path .. " " .. options.dir .. " > " .. file, {
      on_exit = function(jobid, data, event)
      vim.api.nvim_command('bdelete!')
      local f = io.open(file, 'r')
      local stdout = f:read('*all')
      f:close()
      os.remove(file)
      vim.api.nvim_command('edit ' .. stdout)
      end})
end
return M
