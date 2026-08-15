local api = vim.api

local M = {}

M.highlight = "NvimWhiteFloatBorder"
M.chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
M.lsp = vim.tbl_map(function(char)
  return { char, M.highlight }
end, M.chars)
M.cmp_winhighlight = table.concat({
  "Normal:NormalFloat",
  "FloatBorder:" .. M.highlight,
  "CursorLine:PmenuSel",
  "Search:None",
}, ",")

local function apply_highlight()
  api.nvim_set_hl(0, M.highlight, { fg = "#ffffff", bold = true })
end

local group = api.nvim_create_augroup("nvim_white_float_border", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = apply_highlight,
})

apply_highlight()

return M
