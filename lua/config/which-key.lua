local ok, icons = pcall(require, "which-key.icons")
if ok then
  icons.providers = vim.tbl_filter(function(provider)
    return provider.name ~= "mini.icons"
  end, icons.providers)
end

require("which-key").setup {
  preset = "classic",
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 9, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    mappings = true,
    rules = {},
  },
  win = {
    border = "none", -- none, single, double, shadow
    padding = { 1, 0 }, -- extra window padding [top/bottom, right/left]
    title = false,
  },
  layout = {
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 1, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  replace = {
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
      { "^%s+", "" },
    },
  },
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = {
    { "<auto>", mode = "nxso" },
  },
}

require("which-key").add({
  { "gc", desc = "Comments", mode = { "n", "x" } },
})
