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
