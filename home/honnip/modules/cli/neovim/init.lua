
local lazypath = "@lazy_nvim@"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  defaults = { lazy = true },
  spec = "plugins"
})
