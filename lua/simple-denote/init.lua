local M = {}

local api = require("simple-denote.api")
local config = require("simple-denote.config")

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
      return { "note", "retitle", "retag" }
    end,
  })
end

---@param options? table user configuration
function M.setup(options)
  config.options = vim.tbl_deep_extend("force", config.defaults, options or {})
  if config.options.dir:sub(-1) ~= "/" then
    config.options.dir = config.options.dir .. "/"
  end
  M.load_cmd(config.options)
end

return M
