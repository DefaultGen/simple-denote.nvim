local M = {}

local api = require("simple-denote.api")
local config = require("simple-denote.config")

function M.load_cmd(options)
  vim.api.nvim_create_user_command("Denote", function(opts)
    if opts.fargs[1] == "note" then
      api.note(options)
    elseif opts.fargs[1] == "title" then
      api.title(options)
    elseif opts.fargs[1] == "tag" then
      api.tag(options)
    elseif opts.fargs[1] == "signature" then
      api.signature(options)
    else
      error("Unsupported operation " .. opts.fargs[1])
    end
  end, {
    nargs = 1,
    complete = function()
      return { "note", "title", "tag", "signature" }
    end,
  })
end

---Add / to directory if necessary and set the heading_char based on the ext
function M.fix_options()
  if config.options.dir:sub(-1) ~= "/" then
    config.options.dir = config.options.dir .. "/"
  end
  if config.options.ext == "md" then
    config.options.heading_char = "#"
  elseif config.options.ext == "org" or config.options.ext == "norg" then
    config.options.heading_char = "*"
  end
end

---@param options? table user configuration
function M.setup(options)
  config.options = vim.tbl_deep_extend("force", config.defaults, options or {})
  M.fix_options()
  M.load_cmd(config.options)
end

return M
