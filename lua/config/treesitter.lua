-- nvim-treesitter installs parsers beside the plugin. Prefer that directory
-- over legacy parsers in stdpath("data")/site, otherwise a stale parser can be
-- combined with newer queries and fail on newly introduced node types.
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "asm",
    "bash",
    "c",
    "cpp",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "json",
    "lua",
    "ocaml",
    "ocaml_interface",
    "python",
    "rust",
    "toml",
    "vim",
    "vimdoc",
  },
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {}, -- list of language that will be disabled
  },
}
