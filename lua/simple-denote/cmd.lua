local M = {
  commands = { "note", "retitle", "retag" },
}

local api = require("simple-denote.api")

function M.load_cmd(options)
  vim.api.nvim_create_user_command("Denote", function(opts)
    if opts.fargs[1] == "note" then
      api.note(options)
    elseif opts.fargs[1] == "retitle" then
      api.retitle(options)
    elseif opts.fargs[1] == "retag" then
      api.retag(options)
    else
      error("Unsupported operation " .. opts.fargs[1])
    end
  end, {
    nargs = 1,
    complete = function()
      return M.commands
    end,
  })
end

return M
