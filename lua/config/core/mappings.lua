local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic quality-of-life
map("n", "<leader>w", "<cmd>write<cr>", opts)
map("n", "<leader>q", "<cmd>quit<cr>", opts)

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)

-- Window navigation (Ctrl-h/j/k/l)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Make ';' enter command-line (like ':')
-- Note: this overrides Vim's default ';' (repeat f/t). If you need that back, map it elsewhere.
vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true, silent = false })

