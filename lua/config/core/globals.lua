-- Leader keys must be set before loading plugins/mappings.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable some providers you likely don't need (faster startup).
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
-- Keep python provider enabled if you plan to use python tools in nvim.
-- vim.g.loaded_python3_provider = 0

