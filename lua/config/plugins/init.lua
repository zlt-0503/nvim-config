require("config.utils.lazy").bootstrap()

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.notify("lazy.nvim failed to load", vim.log.levels.ERROR)
  return
end

lazy.setup({
  { import = "config.plugins.spec" },
}, {
  defaults = { lazy = true },
  checker = { enabled = true, notify = false }, -- auto-check updates
  change_detection = { notify = false },
  ui = { border = "rounded" },
})

