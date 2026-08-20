local api = vim.api

local M = {}

M.highlight = "NvimWhiteFloatBorder"
M.normal_highlight = "NvimTransparentFloat"
M.selection_highlight = "NvimTransparentFloatSelection"
M.chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
M.lsp = vim.tbl_map(function(char)
  return { char, M.highlight }
end, M.chars)
M.cmp_winhighlight = table.concat({
  "Normal:" .. M.normal_highlight,
  "FloatBorder:" .. M.highlight,
  "CursorLine:" .. M.selection_highlight,
  "Search:None",
}, ",")

local function apply_highlight()
  local normal = api.nvim_get_hl(0, { name = "Normal", link = false })
  local transparent = { bg = "NONE" }
  if normal.fg then
    transparent.fg = normal.fg
  end

  api.nvim_set_hl(0, M.normal_highlight, transparent)
  api.nvim_set_hl(0, M.highlight, { fg = "#ffffff", bg = "NONE", bold = true })
  api.nvim_set_hl(0, M.selection_highlight, {
    fg = "#ffffff",
    bg = "NONE",
    bold = true,
    underline = true,
  })

  -- Cover built-in floats and popup menus in addition to the explicit LSP and
  -- nvim-cmp mappings below.
  api.nvim_set_hl(0, "NormalFloat", transparent)
  api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "NONE", bold = true })
  api.nvim_set_hl(0, "Pmenu", transparent)
  api.nvim_set_hl(0, "PmenuSel", { link = M.selection_highlight })

  -- which-key owns these groups and maps its floating window to them.
  api.nvim_set_hl(0, "WhichKeyNormal", { link = M.normal_highlight })
  api.nvim_set_hl(0, "WhichKeyBorder", { link = M.highlight })
end

local group = api.nvim_create_augroup("nvim_white_float_border", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = apply_highlight,
})

apply_highlight()

if vim.fn.exists("+winborder") == 1 then
  vim.o.winborder = "rounded"
end

return M
