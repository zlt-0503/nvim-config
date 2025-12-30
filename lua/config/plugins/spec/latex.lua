-- LaTeX Support
return {
  {
    "lervag/vimtex",
    ft = { "tex", "latex", "bib" },
    init = function()
      -- VimTeX settings must be set before loading
      vim.g.vimtex_view_method = "zathura" -- or 'mupdf', 'okular', 'evince'
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_indent_enabled = 1

      -- Configure latexmk
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
    config = function()
      -- VimTeX keymaps (plugin handles most of it)
      vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<cr>", { desc = "VimTeX Compile" })
      vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "VimTeX View" })
      vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<cr>", { desc = "VimTeX Clean" })
      vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", { desc = "VimTeX TOC" })
    end,
  },
}
