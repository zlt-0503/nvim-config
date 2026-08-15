# Neovim Configuration

This is a personal Neovim configuration for Fedora/Linux. It is based on the
reference config in `nvim_config_bak`, with local changes for Go, Rust, OCaml,
and Linux kernel development. Python, JavaScript, and Copilot support are
intentionally removed.

The plugin manager is `lazy.nvim`. Plugin specs live in
`lua/plugin_specs.lua`, and plugin-specific Lua configuration lives in
`lua/config/`.

## Nix and Home Manager

This repository is also a standalone flake exporting
`homeManagerModules.default`. The module installs Neovim, its Python provider,
the lazy.nvim bootstrap plugin, core command-line dependencies, and the
language servers configured in `lua/config/lsp.lua`.

Plugins other than lazy.nvim remain managed by lazy.nvim and are pinned by
`lazy-lock.json`. This preserves the existing lazy-loading and plugin build
hooks while Nix manages the editor and external runtime dependencies.

The default module uses an immutable Nix-store copy of the configuration. A
parent dotfiles repository can set `sorasuka.neovim.source` to an absolute
checkout path so the generated `~/.config/nvim` entries point back to that
checkout. This keeps `lazy-lock.json` and the configuration editable in a Git
submodule; changing `init.lua` itself still requires Home Manager activation.

Example Home Manager import:

```nix
{
  imports = [ ./path/to/nvim-config/nix/home-manager.nix ];

  sorasuka.neovim = {
    enable = true;
    source = "/home/user/.config/dotfiles/config/nvim";
  };
}
```

Independent validation:

```sh
nix flake check
```

## Requirements

Required or strongly recommended tools:

- `nvim` 0.11 or newer
- `git`
- `rg`
- A Nerd Font for icons

Optional tools enable optional features:

- `clangd` for C, C++, and kernel-oriented LSP
- `gopls`, `go` for Go
- `rust-analyzer`, `rustc`, `cargo` for Rust
- `ocamllsp`, `ocamlc`, `dune` for OCaml
- `lua-language-server` for Lua
- `vim-language-server` for Vimscript
- `bash-language-server` for shell scripts
- `ltex-ls` for prose, Markdown, and TeX diagnostics
- `ctags` for Vista
- `latex`, `latexmk`, `xelatex`, `pandoc` for TeX and Markdown PDF workflows
- `tmux`, `sbcl`, `trash`, `yazi`, `gdb`

This config does not install external language servers. Install them manually
with your system package manager or language toolchain. Lazy.nvim only manages
Neovim plugins.

## Directory Layout

- `init.lua`: main entry point.
- `lua/globals.lua`: platform flags, providers, leader key, disabled built-ins.
- `viml_conf/options.vim`: core editor options.
- `viml_conf/autocommands.vim`: Vimscript autocommands.
- `lua/custom-autocmd.lua`: Lua autocommands.
- `lua/mappings.lua`: global key mappings and helper functions.
- `viml_conf/plugins.vim`: Vimscript plugin settings and plugin keymaps.
- `lua/plugin_specs.lua`: lazy.nvim bootstrap and plugin specs.
- `lua/config/`: plugin-specific Lua config modules.
- `after/ftplugin/`: filetype-local settings and mappings.
- `ftdetect/`: custom filetype detection.
- `plugin/`: custom commands and abbreviations.
- `autoload/`: Vimscript helper functions and text objects.
- `my_snippets/`: custom UltiSnips snippets.
- `resources/head.tex`: Pandoc/XeLaTeX header for Markdown PDF export.
- `spell/en.utf-8.add`: custom spellfile.
- `lazy-lock.json`: lazy.nvim lockfile.

## Load Order

`init.lua` enables `vim.loader`, then loads:

1. `lua/globals.lua`
2. `viml_conf/options.vim`
3. `viml_conf/autocommands.vim`
4. `lua/mappings.lua`
5. `viml_conf/plugins.vim`
6. `lua/colorschemes.lua`

`viml_conf/plugins.vim` calls `lua require("plugin_specs")`, which bootstraps
lazy.nvim and loads plugin specs.

## Core Behavior

- Leader key: `,`
- Platform flags: `vim.g.is_linux`, `vim.g.is_mac`, `vim.g.is_win`
- Disabled providers: Perl, Ruby, Node
- Python provider: optional; disabled if `python3` is unavailable
- Disabled built-ins: netrw, 2html, zip, gzip, tar, tutor, matchit,
  matchparen, SQL completion
- Language: `en_US.UTF-8`
- Default indent: 4 spaces
- Backups: enabled under Neovim data directory
- Swapfiles: disabled
- Undo files: enabled
- Search: `ignorecase` and `smartcase`
- Grep: uses `rg --vimgrep --no-heading --smart-case` when available
- Clipboard: uses `unnamedplus` when a clipboard provider exists
- UI: line numbers, relative numbers, split below/right, true color,
  persistent sign column

## Plugins

### Plugin Manager

- `folke/lazy.nvim`: plugin manager

Lazy command abbreviations:

- `:pi`: `:Lazy install`
- `:pud`: `:Lazy update`
- `:pc`: `:Lazy clean`
- `:ps`: `:Lazy sync`

### Completion, Snippets, and Editing

- `hrsh7th/nvim-cmp`: completion engine
- `hrsh7th/cmp-nvim-lsp`: LSP completion source
- `onsails/lspkind-nvim`: completion item icons and labels
- `hrsh7th/cmp-path`: path completion
- `hrsh7th/cmp-buffer`: buffer completion
- `hrsh7th/cmp-omni`: omni completion, mainly for TeX
- `hrsh7th/cmp-emoji`: emoji completion
- `quangnguyen30192/cmp-nvim-ultisnips`: UltiSnips completion source
- `SirVer/ultisnips`: snippet engine using the Python provider
- `honza/vim-snippets`: snippet collection
- `windwp/nvim-autopairs`: automatic pairs
- `tpope/vim-commentary`: comment operator
- `907th/vim-auto-save`: automatic save
- `simnalamburt/vim-mundo`: undo tree UI
- `stevearc/dressing.nvim`: improved input/select UI
- `gbprod/yanky.nvim`: yank history
- `tpope/vim-eunuch`: file commands
- `tpope/vim-repeat`: repeat plugin mappings
- `nvim-zh/better-escape.vim`: insert-mode escape helper
- `sbdchd/neoformat`: formatter command
- `chrisbra/unicode.vim`: Unicode character information
- `wellle/targets.vim`: text objects
- `machakann/vim-sandwich`: surround/pair editing
- `michaeljsmith/vim-indent-object`: indent text object
- `machakann/vim-swap`: swap arguments and list items

Platform-specific editing plugins:

- `lyokha/vim-xkbswitch`: macOS input method switching, when available
- `Neur1n/neuims`: Windows input method support

### LSP and Languages

- `neovim/nvim-lspconfig`: server defaults for built-in `vim.lsp.config`
- `nvim-treesitter/nvim-treesitter`: syntax parsers, pinned to `master`
- `fatih/vim-go`: Go filetype support
- `rust-lang/rust.vim`: Rust filetype support
- `ocaml/vim-ocaml`: OCaml filetype support
- `vlime/vlime`: Common Lisp support when `sbcl` exists
- `lervag/vimtex`: TeX support when `latex` exists
- `tmux-plugins/vim-tmux`: tmux config support when `tmux` exists
- `andymass/vim-matchup`: matchit and matchparen replacement
- `tpope/vim-scriptease`: Vimscript tooling
- `skywind3000/asyncrun.vim`: async command runner
- `cespare/vim-toml`: TOML support
- `sakhnik/nvim-gdb`: GDB integration on Linux and Windows
- `zk-org/zk-nvim`: Markdown note workflow

Configured LSP servers are enabled only if their executables are present:

- `ltex`: text, plaintex, tex, markdown
- `clangd`: c, cpp, cc; kernel-aware root markers
- `gopls`: Go
- `rust_analyzer`: Rust
- `ocamllsp`: OCaml
- `vimls`: Vimscript
- `bashls`: shell scripts
- `lua_ls`: Lua

No Python LSP, JavaScript LSP, or Copilot support is configured.

### Search, Navigation, UI, and Files

- `smoka7/hop.nvim`: jump navigation
- `kevinhwang91/nvim-hlslens`: search count and lens display
- `Yggdroot/LeaderF`: fuzzy file, grep, help, tag, buffer, and MRU search
- `nvim-lua/plenary.nvim`: Lua utility dependency
- `nvim-telescope/telescope.nvim`: Telescope picker
- `nvim-telescope/telescope-symbols.nvim`: Telescope symbols
- `nvim-tree/nvim-web-devicons`: icon provider
- `nvim-lualine/lualine.nvim`: statusline
- `akinsho/bufferline.nvim`: buffer tabline
- `nvimdev/dashboard-nvim`: startup dashboard
- `lukas-reineke/indent-blankline.nvim`: indent guides
- `itchyny/vim-highlighturl`: URL highlighting
- `rcarriga/nvim-notify`: notification UI
- `tyru/open-browser.vim`: browser opener on macOS and Windows
- `liuchengxu/vista.vim`: tag sidebar when `ctags` exists
- `kevinhwang91/nvim-bqf`: quickfix UI
- `folke/zen-mode.nvim`: distraction-free editing
- `rhysd/vim-grammarous`: macOS Markdown grammar checking
- `glacambre/firenvim`: browser textarea editing on macOS and Windows
- `tpope/vim-obsession`: session management
- `ojroques/vim-oscyank`: OSC52 clipboard yanking on Linux
- `folke/which-key.nvim`: keybinding popup
- `jdhao/whitespace.nvim`: show and trim trailing whitespace
- `nvim-tree/nvim-tree.lua`: file explorer
- `j-hui/fidget.nvim`: LSP progress UI
- `mikavilpas/yazi.nvim`: Yazi file manager integration

### Git

- `tpope/vim-fugitive`: Git porcelain
- `rbong/vim-flog`: Git log UI
- `akinsho/git-conflict.nvim`: conflict marker handling
- `ruifm/gitlinker.nvim`: repository permalinks
- `lewis6991/gitsigns.nvim`: signs, hunk preview, blame, word diff
- `rhysd/committia.vim`: commit buffer UI
- `sindrets/diffview.nvim`: diff views

### Colorschemes

Installed colorschemes:

- `navarasu/onedark.nvim`
- `sainnhe/edge`
- `sainnhe/sonokai`
- `sainnhe/gruvbox-material`
- `sainnhe/everforest`
- `EdenEast/nightfox.nvim`
- `catppuccin/nvim`
- `olimorris/onedarkpro.nvim`
- `marko-cerovac/material.nvim`
- `folke/tokyonight.nvim`

The active colorscheme is Catppuccin Macchiato with transparent background.
Lualine uses the `catppuccin-macchiato` theme.

## Completion and Snippets

`nvim-cmp` sources:

- LSP
- UltiSnips
- Path
- Buffer
- Emoji
- Omni completion for TeX

Completion mappings:

| Mode | Key | Action |
| --- | --- | --- |
| Insert | `<Tab>` | Next completion item |
| Insert | `<S-Tab>` | Previous completion item |
| Insert | `<CR>` | Confirm completion |
| Insert | `<C-e>` | Abort completion |
| Insert | `<Esc>` | Close completion menu |
| Insert | `<C-d>` | Scroll docs up |
| Insert | `<C-f>` | Scroll docs down |

UltiSnips mappings:

| Mode | Key | Action |
| --- | --- | --- |
| Insert/Snippet | `<C-j>` | Expand or jump forward |
| Insert/Snippet | `<C-k>` | Jump backward |

Custom snippets are loaded from `my_snippets/`:

- `all.snippets`
- `c.snippets`
- `cpp.snippets`
- `go.snippets`
- `markdown.snippets`
- `ocaml.snippets`
- `rust.snippets`
- `snippets.snippets`
- `tex.snippets`
- `vim.snippets`

Python snippets were removed.

## Global Key Mappings

| Mode | Key | Action |
| --- | --- | --- |
| Normal, Visual | `;` | Enter command line |
| Insert | `<C-u>` | Uppercase word under cursor |
| Insert | `<C-t>` | Title-case current word |
| Normal | `<leader>p` | Paste non-linewise text below current line |
| Normal | `<leader>P` | Paste non-linewise text above current line |
| Normal | `<leader>w` | Save current buffer |
| Normal | `<leader>q` | Save if modified and quit current window |
| Normal | `<leader>Q` | Quit all Neovim windows |
| Normal | `[l` / `]l` | Previous/next location item |
| Normal | `[L` / `]L` | First/last location item |
| Normal | `[q` / `]q` | Previous/next quickfix item |
| Normal | `[Q` / `]Q` | First/last quickfix item |
| Normal | `\x` | Close quickfix and location lists |
| Normal | `\d` | Delete current buffer without closing window |
| Normal | `<space>o` | Insert blank line below |
| Normal | `<space>O` | Insert blank line above |
| Normal | `j` / `k` | Move by display line without count |
| Normal | `^` / `0` | Move by display-line start positions |
| Visual | `$` | Move to last nonblank character |
| Normal, Visual | `H` | Move to first nonblank character |
| Normal, Visual | `L` | Move to last nonblank character |
| Visual | `<` / `>` | Shift and reselect |
| Normal | `<leader>ev` | Edit `$MYVIMRC` in a new tab |
| Normal | `<leader>sv` | Save and source `$MYVIMRC` |
| Normal | `<leader>v` | Reselect last pasted text |
| Normal | `/` | Start very-magic search |
| Normal | `<leader>cd` | Change local cwd to current file directory |
| Terminal | `<Esc>` | Leave terminal mode |
| Normal | `<F11>` | Toggle spell checking |
| Insert | `<F11>` | Toggle spell checking |
| Normal | `<F9>` | Run `make` if a Makefile exists |
| Normal | `c`, `C`, `cc` | Change using black-hole register |
| Visual | `c` | Change using black-hole register |
| Normal | `<leader><space>` | Strip trailing whitespace |
| Normal | `<leader>st` | Show syntax group at cursor |
| Normal | `<leader>y` | Yank entire buffer |
| Normal | `<leader>cl` | Toggle cursor column |
| Normal | `<leader>cb` | Blink cursor line and column |
| Normal | `<A-k>` / `<A-j>` | Move current line up/down |
| Visual | `<A-k>` / `<A-j>` | Move selected lines up/down |
| Visual | `p` | Replace selection without overwriting register |
| Normal | `gb` | Next buffer, or counted buffer |
| Normal | `gB` | Previous buffer |
| Normal | Arrow keys | Move between windows |
| Visual, Operator | `iu` | URL text object |
| Visual, Operator | `iB` | Whole-buffer text object |
| Normal | `J` / `gJ` | Join lines without moving cursor |
| Insert | `, . ! ? ; :` | Insert punctuation and break undo sequence |
| Insert | `<A-;>` | Append semicolon at end of line |
| Insert | `<C-A>` / `<C-E>` | Beginning/end of line |
| Command | `<C-A>` | Beginning of command line |
| Insert | `<C-D>` | Delete character to the right |

## Plugin Key Mappings

| Mode | Key | Plugin | Action |
| --- | --- | --- | --- |
| Normal | `<leader>ff` | LeaderF | Search files |
| Normal | `<leader>fg` | LeaderF | Ripgrep project |
| Normal | `<leader>fh` | LeaderF | Search help |
| Normal | `<leader>ft` | LeaderF | Search current-buffer tags |
| Normal | `<leader>fb` | LeaderF | Switch buffers |
| Normal | `<leader>fr` | LeaderF | Search MRU files |
| LeaderF prompt | `<C-J>` / `<C-K>` | LeaderF | Next/previous result |
| Normal, Visual | `<leader>ob` | open-browser | Open URL/search target on macOS/Windows |
| Normal | `<Space>t` | Vista | Toggle tag sidebar |
| Normal | `<Space>u` | Mundo | Toggle undo tree |
| Normal | `ga` | unicode.vim | Show Unicode character info |
| Normal, Operator | `s` | vim-sandwich | Reserved for sandwich behavior |
| TeX Normal | `<F9>` | vimtex | Compile through vimtex or make |
| Normal | `<leader>dg` | nvim-gdb | Start GDB on current file |
| Normal | `<leader>zn` | zk-nvim | New note |
| Normal | `<leader>zo` | zk-nvim | Open/search notes |
| Normal | `<leader>zt` | zk-nvim | Search tags |
| Normal | `<leader>zb` | zk-nvim | Show backlinks |
| Normal | `<leader>zl` | zk-nvim | Show links |
| Normal | `<leader>-` | yazi.nvim | Open Yazi at current file |
| Normal | `<leader>cw` | yazi.nvim | Open Yazi in Neovim cwd |
| Normal | `<C-Up>` | yazi.nvim | Resume/toggle Yazi |
| Yazi UI | `<F1>` | yazi.nvim | Show Yazi help |
| Normal | `<space>s` | nvim-tree | Toggle file explorer |
| Normal | `n` / `N` | hlslens | Next/previous search result |
| Normal | `*` / `#` | hlslens | Search word and start lens |
| Normal, Visual, Operator | `f` | hop.nvim | Two-character jump |
| Normal | `<leader>gs` | fugitive | Git status |
| Normal | `<leader>gw` | fugitive | Git write/add |
| Normal | `<leader>gc` | fugitive | Git commit |
| Normal | `<leader>gd` | fugitive | Git diff split |
| Normal | `<leader>gpl` | fugitive | Git pull |
| Normal | `<leader>gpu` | fugitive | Git push in terminal split |
| Normal, Visual | `<leader>gl` | gitlinker | Get permalink |
| Normal | `<leader>gb` | gitlinker | Open repository URL |
| Normal | `]c` / `[c` | gitsigns | Next/previous hunk |
| Normal | `<leader>hp` | gitsigns | Preview hunk |
| Normal | `<leader>hb` | gitsigns | Blame line |
| Normal | `[y` / `]y` | yanky.nvim | Cycle yank history after paste |

## LSP Key Mappings

These mappings are buffer-local and exist after an LSP server attaches:

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `gd` | Go to definition |
| Normal | `<C-]>` | Go to definition |
| Normal | `K` | Hover |
| Normal | `<C-k>` | Signature help |
| Normal | `<space>rn` | Rename |
| Normal | `gr` | References |
| Normal | `[d` / `]d` | Previous/next diagnostic |
| Normal | `<space>qw` | Put workspace/window diagnostics in quickfix |
| Normal | `<space>qb` | Put buffer diagnostics in quickfix |
| Normal | `<space>ca` | Code action |
| Normal | `<space>wa` | Add workspace folder |
| Normal | `<space>wr` | Remove workspace folder |
| Normal | `<space>wl` | List workspace folders |
| Normal | `<space>f` | Format, if server supports formatting |

Diagnostics:

- Underlines disabled
- Virtual text disabled
- Signs enabled
- Severity sorting enabled
- Hover windows use rounded borders
- CursorHold opens diagnostic float when cursor position changes

## Filetype Behavior

### C and Kernel Development

`after/ftplugin/c.lua` uses Linux-kernel-friendly defaults:

- Hard tabs
- Tab width 8
- Shift width 8
- Text width 80
- Color column 80
- `cindent`
- `<F9>` runs `make` first; otherwise compiles and runs current C file

`ftdetect/kernel.vim` detects:

- `Kconfig*` as `kconfig`
- `*.S` and `*.s` as `asm`

`clangd` uses kernel-aware root markers:

- `compile_commands.json`
- `compile_flags.txt`
- `.clangd`
- `Kbuild`
- `Kconfig`
- `Makefile`
- `.git`

### Assembly

`after/ftplugin/asm.lua` uses hard tabs, width 8, text width 80, and color
column 80.

### C++

`after/ftplugin/cpp.vim`:

- Sets `commentstring=// %s`
- Removes automatic comment insertion on new lines
- `<F9>` runs `make` if possible; otherwise compiles and runs with `g++` or
  `clang++`

### Go

`after/ftplugin/go.lua`:

- Uses hard tabs
- `<F9>` runs `make` if possible
- If `go.mod` exists, runs `:GoRun`
- Otherwise runs `go run` on the current file

### Rust

`after/ftplugin/rust.lua`:

- Uses 4-space indentation
- Text width and color column 100
- `<F9>` runs `make` first
- Uses `cargo run` when `Cargo.toml` exists
- Otherwise compiles and runs the current file with `rustc`

### OCaml

`after/ftplugin/ocaml.lua`:

- Uses 2-space indentation
- Sets OCaml block comment string
- `<F9>` runs `make` first
- Uses `dune build` for Dune projects
- Otherwise compiles and runs the current file with `ocamlc`

`ftdetect/ocaml.vim` detects:

- `dune` and `dune-project`
- `*.ml`
- `*.mli`

### Markdown

Markdown settings include:

- Wrapped lines
- Larger syntax sync limit
- Footnote mappings via `vim-markdownfootnotes`
- Fenced-code-block text objects
- Operators for list markers and hard line breaks

### TeX

TeX settings include:

- Vimtex compilation on `<F9>`
- `latexmk` build directory `build`
- XeLaTeX options for file-line-error, synctex, and nonstop mode
- TOC window settings

### Other Filetypes

- Lua: `<F9>` sources current file unless a Makefile exists
- Vimscript: `<F9>` sources current file unless a Makefile exists
- JSON: Tree-sitter folding
- YAML: disables syntax on files over 500 lines
- Quickfix: resizes quickfix windows between 5 and 15 lines
- SQL: SQL comment string
- Git config: shell-style comment string

Python and JavaScript ftplugins were removed.

## Custom Commands

Defined in `plugin/command.vim`:

- `:Redir {cmd}`: capture command output in a scratch tab
- `:Edit {files...}`: multi-edit glob-expanded files
- `:Datetime [timestamp]`: show current time or convert Unix timestamps
- `:ToPDF`: convert current Markdown file to PDF with Pandoc and XeLaTeX
- `:[range]JSONFormat`: format JSON using Neovim's built-in Lua JSON support
- `:StartVlime`: start VLime backend when available

Command-line abbreviations:

- `:edit` expands to `:Edit`
- `:man` expands to `:Man`
- `:git` expands to `:Git` after fugitive config loads

Insert abbreviations:

- `reqire` becomes `require`
- `serveral` becomes `several`

## Autocommands

Important autocommands:

- Restore cursor position when reopening files
- Toggle relative number based on focus and insert mode
- Highlight yanked text
- Preserve cursor position during yank
- Create missing parent directories before writing
- Auto-reload changed files on focus/cursor hold
- Equalize windows on resize
- Open NvimTree when Neovim starts on a directory
- Handle large files by disabling expensive behavior
- Trigger `User InGitRepo` when inside a Git repository

## Miscellaneous Notes

- `nvim-treesitter` is pinned to `master` because the `main` branch is an
  incompatible rewrite and does not provide `nvim-treesitter.configs`.
- LSP setup uses `vim.lsp.config` and `vim.lsp.enable`, not the deprecated
  `require("lspconfig").setup` framework.
- `which-key.nvim` uses the v3 option schema.
- `health-filter.lua` exists in the tree but is not loaded, so `:checkhealth`
  warnings remain visible.
- `lazy-lock.json` pins plugin versions.
- Catppuccin is configured with flavor `macchiato`.
- Copilot is intentionally not installed or configured.
- Python and JavaScript language support are intentionally not configured.
