local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 180 })
  end,
})

-- Resize splits when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

local function set_transparent()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "MsgArea",
    "NormalFloat",
    "FloatBorder",
    "WinSeparator",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
end

-- Apply now
set_transparent()

-- Re-apply after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparentBG", { clear = true }),
  callback = set_transparent,
})

