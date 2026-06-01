# Neovim Config Recreation Reference

Generated from the local config in `~/.config/nvim` on 2026-06-01. This file is intended as a handoff prompt/reference for recreating the same Neovim setup on a Fedora desktop.

Important: the local worktree is not identical to upstream `https://github.com/jdhao/nvim-config.git`. To recreate this exact setup, copy the current local tree, including untracked files such as `lazy-lock.json`, `lua/config/health-filter.lua`, `lua/config/nvim-autopairs.lua`, and the local `pack/` directory if you want the vendored Copilot copy preserved. Do not rely only on cloning upstream.

## Load Order

`init.lua` enables `vim.loader` and then loads these files/modules in order:

1. `lua/globals.lua`
2. `viml_conf/options.vim`
3. `viml_conf/autocommands.vim`
4. `lua/mappings.lua`
5. `viml_conf/plugins.vim`
6. `lua/config/health-filter.lua`
7. `lua/colorschemes.lua`

`viml_conf/plugins.vim` calls `lua require('plugin_specs')`, which bootstraps `lazy.nvim` into `stdpath("data") .. "/lazy/lazy.nvim"` and then installs/configures plugins from `lua/plugin_specs.lua`.

## Directory Layout

```text
.
├── init.lua                         # main entrypoint and source order
├── ginit.vim                        # GUI-only Neovim settings
├── lazy-lock.json                   # lazy.nvim plugin lockfile, currently untracked
├── lua/
│   ├── globals.lua                  # OS flags, providers, mapleader, builtin plugin disables
│   ├── mappings.lua                 # global key mappings and NvimConfig helpers
│   ├── plugin_specs.lua             # lazy.nvim specs
│   ├── colorschemes.lua             # active colorscheme setup
│   ├── custom-autocmd.lua           # Lua autocommands
│   ├── utils.lua                    # Lua utility helpers
│   └── config/                      # plugin-specific Lua config modules
├── viml_conf/
│   ├── options.vim                  # core Vim options
│   ├── autocommands.vim             # Vimscript autocommands
│   └── plugins.vim                  # Vimscript plugin settings and plugin keymaps
├── plugin/
│   ├── abbrev.vim                   # insert abbreviations
│   ├── command.vim                  # custom commands
│   └── log-autocmds.vim             # autocmd logging command
├── autoload/
│   ├── utils.vim                    # Vimscript utility functions
│   ├── buf_utils.vim                # buffer navigation helper
│   └── text_obj.vim                 # URL, Markdown code block, whole-buffer text objects
├── after/ftplugin/                  # filetype-local overrides and mappings
├── ftdetect/                        # custom filetype detection
├── my_snippets/                     # custom UltiSnips snippets
├── spell/en.utf-8.add               # custom spellfile
├── resources/head.tex               # Pandoc/LaTeX PDF header used by :ToPDF
├── docs/                            # existing setup docs/scripts
└── pack/github/start/copilot.vim/   # vendored Copilot runtime copy, currently untracked
```

Other support files:

- `.stylua.toml`: StyLua config, 2-space indent, Unix line endings, `AutoPreferDouble` quote style.
- `.gitignore`: ignores tags, compiled spellfile, executables, netrw history, logs, `.DS_Store`.
- `_config.yml`: Jekyll theme metadata.

## Fedora-Specific Behavior

On Fedora, `vim.g.is_linux` will be true, while `vim.g.is_mac` and `vim.g.is_win` will be false.

Conditionally enabled on Fedora:

- `sakhnik/nvim-gdb` because it is enabled on Windows or Linux.
- `ojroques/vim-oscyank` because it is Linux-only.
- `vlime/vlime` only if `sbcl` exists.
- `liuchengxu/vista.vim` only if `ctags` exists.
- `lervag/vimtex` only if `latex` exists.
- `tmux-plugins/vim-tmux` only if `tmux` exists.

Conditionally disabled on Fedora by the current config:

- `nvim-treesitter/nvim-treesitter`, because the spec enables it only on macOS.
- `tyru/open-browser.vim`, because it is enabled only on macOS/Windows.
- `glacambre/firenvim`, because it is enabled only on macOS/Windows.
- `rhysd/vim-grammarous`, because it is macOS-only.
- `lyokha/vim-xkbswitch`, because it is macOS-only and also needs `xkbswitch`.
- `Neur1n/neuims`, because it is Windows-only.

Do not silently change these conditions if the goal is exact recreation. Note that some `after/ftplugin` files still set `foldexpr=nvim_treesitter#foldexpr()`, so the exact Fedora behavior may include missing Tree-sitter folding support unless the condition is changed later.

## Core Globals

From `lua/globals.lua`:

- `vim.g.mapleader = ","`.
- OS globals: `is_win`, `is_linux`, `is_mac`.
- `vim.g.logging_level = "info"`.
- Disables Perl, Ruby, and Node providers.
- Requires `python3`; sets `vim.g.python3_host_prog` to the discovered executable.
- Uses `language en_US.UTF-8`.
- Disables builtin menus, netrw/netrwPlugin, `2html`, zip/gzip/tar plugins, tutor, builtin matchit/matchparen, and SQL omni completion.
- Sets `vim.g.vimsyn_embed = "l"` for Lua heredoc highlighting inside Vimscript.

## Core Options

From `viml_conf/options.vim`:

- UI and behavior:
  - `fillchars=fold:\ ,vert:\│,eob:\ ,msgsep:‾,diff:╱`
  - `splitbelow`, `splitright`
  - `timeoutlen=500`, `updatetime=500`
  - `number`, `relativenumber`
  - `termguicolors`
  - `signcolumn=yes:1`
  - `noshowmode`, `noruler`
  - `confirm`, `visualbell`, `noerrorbells`
  - `mouse=nic`, `mousemodel=popup`, `mousescroll=ver:1,hor:0`
  - `scrolloff=3`
  - `nowrap`
- Files:
  - Enables `clipboard+=unnamedplus` when a clipboard provider exists.
  - `noswapfile`
  - Enables backups in `stdpath("data")/backup//` with `backupcopy=yes`.
  - `undofile`
  - `fileformats=unix,dos`
  - `fileencoding=utf-8` for modifiable buffers.
  - `fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1`
- Indent:
  - Global `tabstop=4`, `softtabstop=4`, `shiftwidth=4`, `expandtab`, `shiftround`.
- Search/completion:
  - `ignorecase`, `smartcase`
  - If `rg` exists: `grepprg=rg --vimgrep --no-heading --smart-case`, `grepformat=%f:%l:%c:%m`.
  - `wildignore` excludes build artifacts, VCS dirs, images, bytecode, `.DS_Store`, and LaTeX artifacts.
  - `wildignorecase`
  - `wildmode=list:longest`
  - `completeopt+=menuone`, `completeopt-=preview`
  - `pumheight=10`, `pumblend=10`, `winblend=0`
  - Insert completion uses spell keywords and removes whole-buffer/unloaded/tag sources: `complete+=kspell complete-=w complete-=b complete-=u complete-=t`.
- Text display/editing:
  - `linebreak`, `showbreak=↪`
  - `listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣`
  - `spelllang=en,cjk`, `spellsuggest+=9`
  - `virtualedit=block`
  - `formatoptions+=mM`
  - `tildeop`
  - `synmaxcol=250`
  - `nostartofline`
  - `matchpairs` includes CJK/typographic pairs.
- Diff:
  - `diffopt=vertical,filler,closeoff,context:3,internal,indent-heuristic,algorithm:histogram,linematch:60`
- Title:
  - `titlestring=%{utils#Get_titlestr()}` shows host on Linux, full path, and file mtime.
- Cursor:
  - `guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20`

## Autocommands

From `viml_conf/autocommands.vim`:

- Temporarily disables `smartcase` in command-line mode, restores it afterward.
- Terminal buffers hide absolute/relative numbers and start in Insert mode.
- Syncs syntax from start on every `BufEnter`.
- Restores last cursor position on `BufReadPost`, unless a `+line` argument was used or the filetype is commit.
- Toggles relative numbers: enabled in normal focused windows, disabled in insert/unfocused/leaving windows.
- On every `ColorScheme`, defines highlights for `YankColor`, `Cursor`, `Cursor2`, `FloatBorder`, and `MatchParen`.
- Auto-quits Neovim when only quickfix, Vista, or NvimTree windows remain.
- On `VimEnter` and `DirChanged`, calls `utils#Inside_git_repo()` and triggers `User InGitRepo`.
- Handles large files over 10 MB by disabling events, relative number, swap, normal buffer retention, and undo.
- Loads `lua/custom-autocmd.lua`.

From `lua/custom-autocmd.lua`:

- Warns when a file is not UTF-8 on `BufRead`.
- Highlights yanked text with `YankColor` for 300 ms.
- Saves/restores cursor position around yanks so yank operations do not move the cursor.
- Creates parent directories before writing missing paths.
- Auto-reloads files changed on disk on `FocusGained` and `CursorHold`; notifies after reload.
- Equalizes windows on `VimResized`.
- If Neovim opens a directory, replaces the directory buffer with a new buffer and opens NvimTree.

## Plugin Manager

`lua/plugin_specs.lua` bootstraps and configures `folke/lazy.nvim`.

Lazy options:

- Lua rocks disabled.
- UI border is rounded.
- UI title is `Plugin Manager`, centered.

Plugin command abbreviations from `viml_conf/plugins.vim`:

- `:pi` expands to `:Lazy install`
- `:pud` expands to `:Lazy update`
- `:pc` expands to `:Lazy clean`
- `:ps` expands to `:Lazy sync`

`lazy-lock.json` currently pins 84 resolved plugin entries. Preserve it for exact versions. On Fedora, Linux-only conditional plugins may be installed and added to the lock if they were absent from the macOS-generated lock.

## Plugin Inventory

Canonical repository/plugin list from `lua/plugin_specs.lua`:

- `hrsh7th/nvim-cmp`
- `hrsh7th/cmp-nvim-lsp`
- `onsails/lspkind-nvim`
- `hrsh7th/cmp-path`
- `hrsh7th/cmp-buffer`
- `hrsh7th/cmp-omni`
- `hrsh7th/cmp-emoji`
- `quangnguyen30192/cmp-nvim-ultisnips`
- `neovim/nvim-lspconfig`
- `github/copilot.vim`
- `nvim-treesitter/nvim-treesitter`
- `Vimjas/vim-python-pep8-indent`
- `jeetsukumaran/vim-pythonsense`
- `machakann/vim-swap`
- `vlime/vlime`
- `smoka7/hop.nvim`
- `kevinhwang91/nvim-hlslens`
- `Yggdroot/LeaderF`
- `nvim-lua/plenary.nvim`
- `nvim-telescope/telescope.nvim`
- `nvim-telescope/telescope-symbols.nvim`
- `navarasu/onedark.nvim`
- `sainnhe/edge`
- `sainnhe/sonokai`
- `sainnhe/gruvbox-material`
- `sainnhe/everforest`
- `EdenEast/nightfox.nvim`
- `catppuccin/nvim` as `catppuccin`
- `olimorris/onedarkpro.nvim`
- `marko-cerovac/material.nvim`
- `folke/tokyonight.nvim`
- `nvim-tree/nvim-web-devicons`
- `nvim-lualine/lualine.nvim`
- `akinsho/bufferline.nvim`
- `nvimdev/dashboard-nvim`
- `lukas-reineke/indent-blankline.nvim`
- `itchyny/vim-highlighturl`
- `rcarriga/nvim-notify`
- `tyru/open-browser.vim`
- `liuchengxu/vista.vim`
- `SirVer/ultisnips`
- `honza/vim-snippets`
- `windwp/nvim-autopairs`
- `tpope/vim-commentary`
- `907th/vim-auto-save`
- `simnalamburt/vim-mundo`
- `stevearc/dressing.nvim`
- `gbprod/yanky.nvim`
- `tpope/vim-eunuch`
- `tpope/vim-repeat`
- `nvim-zh/better-escape.vim`
- `lyokha/vim-xkbswitch`
- `Neur1n/neuims`
- `sbdchd/neoformat`
- `tpope/vim-fugitive`
- `rbong/vim-flog`
- `akinsho/git-conflict.nvim`
- `ruifm/gitlinker.nvim`
- `lewis6991/gitsigns.nvim`
- `rhysd/committia.vim`
- `sindrets/diffview.nvim`
- `kevinhwang91/nvim-bqf`
- `preservim/vim-markdown`
- `vim-pandoc/vim-markdownfootnotes`
- `godlygeek/tabular`
- `zk-org/zk-nvim`
- `folke/zen-mode.nvim`
- `rhysd/vim-grammarous`
- `chrisbra/unicode.vim`
- `wellle/targets.vim`
- `machakann/vim-sandwich`
- `michaeljsmith/vim-indent-object`
- `lervag/vimtex`
- `tmux-plugins/vim-tmux`
- `andymass/vim-matchup`
- `tpope/vim-scriptease`
- `skywind3000/asyncrun.vim`
- `cespare/vim-toml`
- `glacambre/firenvim`
- `sakhnik/nvim-gdb`
- `tpope/vim-obsession`
- `ojroques/vim-oscyank`
- `gelguy/wilder.nvim`
- `folke/which-key.nvim`
- `jdhao/whitespace.nvim`
- `nvim-tree/nvim-tree.lua`
- `j-hui/fidget.nvim`
- `mikavilpas/yazi.nvim`

### Completion, Snippets, And Editing

| Plugin | Purpose / load condition |
| --- | --- |
| `hrsh7th/nvim-cmp` | Main completion engine, `VeryLazy`; configured in `lua/config/nvim-cmp.lua`. |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source for `nvim-cmp`. |
| `onsails/lspkind-nvim` | Completion item symbols/text. |
| `hrsh7th/cmp-path` | Path completion source. |
| `hrsh7th/cmp-buffer` | Buffer completion source. |
| `hrsh7th/cmp-omni` | Omni completion source, used for TeX. |
| `hrsh7th/cmp-emoji` | Emoji completion source. |
| `quangnguyen30192/cmp-nvim-ultisnips` | UltiSnips completion source. |
| `SirVer/ultisnips` | Snippet engine, `InsertEnter`. |
| `honza/vim-snippets` | Snippet collection dependency. |
| `windwp/nvim-autopairs` | Auto pairs, `InsertEnter`; adds TeX `$...$` and `\(...\)` rules. |
| `tpope/vim-commentary` | Comment mappings, `VeryLazy`. |
| `907th/vim-auto-save` | Auto-save, `InsertEnter`; `g:auto_save=1`. |
| `simnalamburt/vim-mundo` | Undo tree UI, `:MundoToggle` / `:MundoShow`. |
| `stevearc/dressing.nvim` | Better UI for Neovim prompts/selects. |
| `gbprod/yanky.nvim` | Yank history, `:YankyRingHistory`; memory ring length 50. |
| `tpope/vim-eunuch` | File commands such as `:Rename`, `:Delete`. |
| `tpope/vim-repeat` | Repeat plugin mappings. |
| `nvim-zh/better-escape.vim` | Escape helper, `InsertEnter`, interval 200 ms. |
| `lyokha/vim-xkbswitch` | macOS input method switch, requires `xkbswitch`. |
| `Neur1n/neuims` | Windows input method integration. |
| `wellle/targets.vim` | Extra text objects. |
| `machakann/vim-sandwich` | Pair/surround manipulation; `s` is unmapped to avoid conflict. |
| `michaeljsmith/vim-indent-object` | Indentation text object. |
| `machakann/vim-swap` | Swap arguments/items, `VeryLazy`. |
| `chrisbra/unicode.vim` | Unicode lookup, `VeryLazy`; maps `ga`. |
| `github/copilot.vim` | GitHub Copilot, command `:Copilot` and `InsertEnter`; `<Tab>` mapping disabled and `copilot_assume_mapped` set. |

### LSP, Languages, And Build Tools

| Plugin | Purpose / load condition |
| --- | --- |
| `neovim/nvim-lspconfig` | LSP client configs on `BufRead`/`BufNewFile`. |
| `nvim-treesitter/nvim-treesitter` | Parser/highlighting, but enabled only on macOS in current spec. |
| `Vimjas/vim-python-pep8-indent` | Python indentation, Python filetype only. |
| `jeetsukumaran/vim-pythonsense` | Python text objects, Python filetype only. |
| `vlime/vlime` | Common Lisp IDE support, only when `sbcl` exists. |
| `sbdchd/neoformat` | Formatting command `:Neoformat`. |
| `lervag/vimtex` | TeX support, only when `latex` exists. |
| `tmux-plugins/vim-tmux` | tmux config highlighting, only when `tmux` exists. |
| `andymass/vim-matchup` | Modern matchit/matchparen replacement. |
| `tpope/vim-scriptease` | Vimscript tools: `:Scriptnames`, `:Message`, `:Verbose`. |
| `skywind3000/asyncrun.vim` | Async command execution through `:AsyncRun`. |
| `cespare/vim-toml` | TOML support. |
| `sakhnik/nvim-gdb` | Debugger support, enabled on Linux/Windows. |
| `gelguy/wilder.nvim` | Cmdline/search completion; `:UpdateRemotePlugins` build. |
| `zk-org/zk-nvim` | Markdown zk notes, command and Markdown filetype triggered. |
| `preservim/vim-markdown` | Markdown support, Markdown filetype only. |
| `vim-pandoc/vim-markdownfootnotes` | Markdown footnote helpers, Markdown filetype only. |
| `godlygeek/tabular` | Table alignment through `:Tabularize`, used by Markdown workflows. |

### Search, Navigation, UI, And Files

| Plugin | Purpose / load condition |
| --- | --- |
| `smoka7/hop.nvim` | Jump navigation; remaps `f` to two-character hop. |
| `kevinhwang91/nvim-hlslens` | Search lens/count display; remaps search navigation. |
| `Yggdroot/LeaderF` | File/buffer/help/tag/RG search; builds C extension off Windows. |
| `nvim-lua/plenary.nvim` | Common Lua dependency. |
| `nvim-telescope/telescope.nvim` | Telescope command support. |
| `nvim-telescope/telescope-symbols.nvim` | Telescope symbols extension. |
| `nvim-tree/nvim-web-devicons` | Icons for UI plugins. |
| `nvim-lualine/lualine.nvim` | Statusline; current active config only sets `theme = "catppuccin"`. |
| `akinsho/bufferline.nvim` | Buffer tabline; disabled in Firenvim. |
| `nvimdev/dashboard-nvim` | Startup dashboard; inline `hyper` theme config in plugin spec. |
| `lukas-reineke/indent-blankline.nvim` | Indent guides via `ibl`; disabled in insert mode. |
| `itchyny/vim-highlighturl` | URL highlighting and URL text-object pattern source. |
| `rcarriga/nvim-notify` | Notification UI; replaces `vim.notify`. |
| `tyru/open-browser.vim` | Browser opener, macOS/Windows only. |
| `liuchengxu/vista.vim` | Tag/sidebar viewer, only when `ctags` exists. |
| `kevinhwang91/nvim-bqf` | Better quickfix UI, quickfix filetype only. |
| `folke/zen-mode.nvim` | Distraction-free editing via `:ZenMode`. |
| `rhysd/vim-grammarous` | Grammar checking, macOS Markdown only. |
| `glacambre/firenvim` | Browser textarea editing, macOS/Windows only. |
| `tpope/vim-obsession` | Session management through `:Obsession`. |
| `ojroques/vim-oscyank` | OSC52 clipboard yank, Linux only. |
| `folke/which-key.nvim` | Keybinding popup/help. |
| `jdhao/whitespace.nvim` | Show and trim trailing whitespace. |
| `nvim-tree/nvim-tree.lua` | File explorer, mapped to `<space>s`. |
| `j-hui/fidget.nvim` | LSP progress UI, legacy tag. |
| `mikavilpas/yazi.nvim` | Yazi terminal file manager integration. |

### Git

| Plugin | Purpose / load condition |
| --- | --- |
| `tpope/vim-fugitive` | Git porcelain inside Vim, lazy-loaded on `User InGitRepo`. |
| `rbong/vim-flog` | Git log UI through `:Flog`. |
| `akinsho/git-conflict.nvim` | Git conflict marker handling. |
| `ruifm/gitlinker.nvim` | Generate repo/file permalinks. |
| `lewis6991/gitsigns.nvim` | Git signs, hunk preview/blame, word diff. |
| `rhysd/committia.vim` | Git commit buffer UI. |
| `sindrets/diffview.nvim` | Diff views. |

### Colorschemes

All are listed in `plugin_specs.lua`, mostly lazy-loaded:

- `navarasu/onedark.nvim`
- `sainnhe/edge`
- `sainnhe/sonokai`
- `sainnhe/gruvbox-material`
- `sainnhe/everforest`
- `EdenEast/nightfox.nvim`
- `catppuccin/nvim` as `catppuccin`
- `olimorris/onedarkpro.nvim`
- `marko-cerovac/material.nvim`
- `folke/tokyonight.nvim`

Current active colorscheme behavior in `lua/colorschemes.lua`:

- Only `catppuccin` is active in `M.colorscheme_conf`; `sonokai` and `tokyonight` blocks are commented.
- Catppuccin flavor is `macchiato`.
- Background is transparent.
- End-of-buffer markers are hidden.
- Comment and conditional styles are italic.
- Integrations enabled for `cmp`, `gitsigns`, `nvimtree`, `treesitter`, and `mini`; `notify` integration disabled.

## Completion And Snippet Config

`lua/config/nvim-cmp.lua`:

- Snippet expansion calls `UltiSnips#Anon`.
- Insert-mode completion mappings:
  - `<Tab>`: next completion item, otherwise fallback.
  - `<S-Tab>`: previous completion item, otherwise fallback.
  - `<CR>`: confirm selected item, `select = true`.
  - `<C-e>`: abort completion.
  - `<Esc>`: close menu.
  - `<C-d>` / `<C-f>`: scroll docs up/down by 4.
- Default sources: `nvim_lsp`, `ultisnips`, `path`, `buffer` with `keyword_length=2`, `emoji`.
- Completion keyword length is 1 and `completeopt = "menu,noselect"`.
- Entries view is `custom`.
- Formatting uses `lspkind.cmp_format` with source labels `[LSP]`, `[US]`, `[Lua]`, `[Path]`, `[Buffer]`, `[Emoji]`, `[Omni]`.
- TeX filetype sources: `omni`, `ultisnips`, `buffer`, `path`.
- Defines VS Code-like completion menu highlight groups.

UltiSnips settings from `viml_conf/plugins.vim`:

- Expand trigger: `<C-j>`.
- Jump forward: `<C-j>`.
- Jump backward: `<C-k>`.
- SnipMate snippets disabled.
- Snippet directories: `UltiSnips`, `my_snippets`.

Wilder cmdline completion:

- Modes: `:`, `/`, `?`.
- Next: `<Tab>`.
- Previous: `<S-Tab>`.
- Accept: `<C-y>`.
- Reject: `<C-e>`.
- Uses Python fuzzy pipelines and a popup menu renderer with devicons, scrollbar, max height 15, accent color `#f4468f`.

## LSP Config

`lua/config/lsp.lua` attaches these mappings to every LSP buffer:

| Mode | Key | Action |
| --- | --- | --- |
| normal | `gd` | Go to definition. |
| normal | `<C-]>` | Go to definition. |
| normal | `K` | Hover. |
| normal | `<C-k>` | Signature help. |
| normal | `<space>rn` | Rename. |
| normal | `gr` | References. |
| normal | `[d` | Previous diagnostic. |
| normal | `]d` | Next diagnostic. |
| normal | `<space>qw` | Put window/workspace diagnostics in quickfix. |
| normal | `<space>qb` | Put current-buffer diagnostics in quickfix. |
| normal | `<space>ca` | Code action. |
| normal | `<space>wa` | Add workspace folder. |
| normal | `<space>wr` | Remove workspace folder. |
| normal | `<space>wl` | Print workspace folders. |
| normal | `<space>f` | Format, only if server supports document formatting. |

Server setup is executable-gated:

- `pylsp`: uses `black`, `pylint`, `pylsp_mypy`, fuzzy `jedi_completion`, and `isort`. Disables `autopep8`, `yapf`, `ruff`, `pyflakes`, and `pycodestyle`. Mypy uses `$VIRTUAL_ENV/bin/python3` when available, otherwise `vim.g.python3_host_prog`.
- `ltex-ls`: filetypes `text`, `plaintex`, `tex`, `markdown`, language `en`.
- `clangd`: filetypes `c`, `cpp`, `cc`.
- `rust-analyzer`.
- `vim-language-server` as `vimls`.
- `bash-language-server` as `bashls`.
- `lua-language-server` as `lua_ls`, with `LuaJIT`, `vim` diagnostic global, and workspace libraries from `$VIMRUNTIME` and `stdpath("config")`.

Diagnostics:

- Underline disabled.
- Virtual text disabled.
- Signs enabled.
- Severity sorting enabled.
- Diagnostic signs are `🆇`, `⚠️`, `ℹ️`, and ``.
- CursorHold opens a rounded diagnostic float if cursor position changed.
- Document highlighting links `LspReference*` groups to `Visual`.
- Hover handler uses rounded borders.

## Plugin Config Highlights

- Bufferline:
  - Shows buffer IDs as numbers.
  - Uses `bdelete! %d` as close command.
  - Filters out filetypes `qf`, `fugitive`, `git`.
  - Hides buffer icons, shows close icons, separator style `bar`, sorted by buffer ID.
- Hlslens:
  - `calm_down = true`, `nearest_only = true`.
  - Remaps `n`, `N`, `*`, `#` to keep search centered and start hlslens.
- Indent Blankline:
  - Uses `▏` as indent char.
  - Hides scope start/end.
  - Excludes `help`, `git`, `markdown`, `snippets`, `text`, `gitconfig`, `alpha`, `dashboard`, and terminal buffers.
  - Disables on `InsertEnter`, re-enables on `InsertLeave` when filetype is not excluded.
- Hop:
  - Case-insensitive, two-character fallback key `<CR>`, quit key `<Esc>`, match mappings `zh_sc`.
  - Remaps `f` in normal/visual/operator mode.
- GitSigns:
  - Signs: add `+`, change `~`, delete `_`, topdelete `‾`, changedelete `│`.
  - `word_diff = true`.
  - Maps `[c`, `]c`, `<leader>hp`, `<leader>hb`.
- GitLinker:
  - Custom `dev.azure.com` URL callback.
  - Default mappings disabled; custom mappings are `<leader>gl` and `<leader>gb`.
- NvimTree:
  - Width 30, left side, sort by name, git enabled with ignored files hidden, dotfiles visible.
  - Trash command is `trash`.
  - Window picker excludes `notify`, `qf`, `diff`, `fugitive`, `fugitiveblame`, `nofile`, `terminal`, and `help`.
- Yanky:
  - Memory-backed ring length 50.
  - Cursor preservation disabled.
- Notify:
  - `fade_in_slide_out`, timeout 1500 ms, background `#2E3440`.
- BQF:
  - No auto height resize.
  - No auto preview.
- Zen Mode:
  - Backdrop `0.8`, width 120.
  - Disables cursorline, cursorcolumn, fold column, and list chars inside zen window.
- Which-key:
  - Marks, registers, spelling, operators, motions, text objects, windows, nav, z, and g presets enabled.
  - `gc` operator labeled as Comments.
  - Icons use breadcrumb `»`, separator `➜`, group `+`.
  - Popup at bottom with no border and compact padding.
  - Blacklists normal-mode triggers `o` and `O`.
- Fidget:
  - Default setup.
- Dashboard:
  - Active config is inline in `plugin_specs.lua`, not `lua/config/dashboard-nvim.lua`.
  - Uses `hyper` theme.
  - Header spells `SORASUKA`.
  - Footer randomly selects from a one-item list: `私たちはもえ舞台の上`.
  - Header/footer highlight color `#ffb7c5`.
- Lualine:
  - Active config is inline in `plugin_specs.lua`, not `lua/config/statusline.lua`.
  - Current active options only set `theme = "catppuccin"`.
  - `lua/config/statusline.lua` exists but is not required by the current plugin spec.
- Health filter:
  - Overrides `vim.health.warn` and `vim.health.report_warn` to no-op, reducing `:checkhealth` warning output.

Unused or currently inactive config modules:

- `lua/config/iron.lua`: configures `iron` with Python `ipython` REPL and vertical 120 split, but no active plugin spec references it.
- `lua/config/statusline.lua`: richer lualine setup, but currently commented out in `plugin_specs.lua`.
- `lua/config/dashboard-nvim.lua`: alternative Doom dashboard setup, but currently commented out in `plugin_specs.lua`.

## Vimscript Plugin Settings

From `viml_conf/plugins.vim`:

- VLime:
  - Adds `:StartVlime`, which starts `sbcl --load {g:package_home}/vlime/lisp/start-vlime.lisp`.
- LeaderF:
  - Disables disk cache and memory cache.
  - Ignores common generated/binary/media/archive/font/document files.
  - Disables devicons on Linux.
  - Uses `FullPath` default mode.
  - Popup width is 80% of columns, capped at 140.
  - Does not use version-control tools for file listing.
  - Uses `rg` as external search tool.
  - Shows hidden files.
  - Clears default `<leader>f` and `<leader>b` shortcuts.
  - Uses working directory mode `a`.
  - Popup colorscheme is `gruvbox_material`.
  - Prompt-mode `<C-J>` and `<C-K>` are remapped to next/previous item.
  - Preview is disabled for File, Buffer, MRU, Line, Colorscheme, Rg, and Gtags; enabled for BufTag and Function.
- open-browser:
  - On macOS/Windows, disables netrw `gx` and maps `<leader>ob`.
- Vista:
  - Removes member icon, disables cursor echo, does not stay in current window on open.
- Mundo:
  - `g:mundo_verbose_graph = 0`, `g:mundo_width = 80`.
- better-escape:
  - `g:better_escape_interval = 200`.
- xkbswitch:
  - `g:XkbSwitchEnabled = 1`.
- Neoformat:
  - Python formatters: `black`, `yapf`.
  - C/C++ formatter: `clang-format` with `--style="{IndentWidth: 4}"`.
- vim-markdown:
  - Header folding disabled.
  - Conceal enabled.
  - TeX conceal disabled and Markdown math disabled.
  - YAML, TOML, and JSON front matter enabled.
  - TOC window autofit enabled.
- vim-grammarous:
  - macOS-only LanguageTool command `languagetool`.
  - Many grammar rules disabled in `g:grammarous#disabled_rules`.
- vimtex:
  - Latexmk build directory `build`.
  - Uses `xelatex`, `-file-line-error`, `-synctex=1`, `-interaction=nonstopmode`.
  - TOC window named `TOC`, width 30, includes content/todo/include layers.
  - Windows viewer is SumatraPDF.
  - macOS viewer is Skim `displayline`, with compile-success refresh.
- vim-matchup:
  - Deferred matchparen enabled.
  - Normal timeout 100 ms, insert timeout 30 ms.
  - Overrides vimtex matching.
  - Does not match delimiters in comments/strings.
  - Offscreen matches shown in popup.
- asyncrun:
  - Opens quickfix height 6 automatically.
  - Uses `gbk` command output encoding on Windows.
- firenvim:
  - Uses `Iosevka Nerd Font:h18` on macOS and `Consolas` elsewhere.
  - Browser textareas use Neovim command line, selector `textarea`, takeover `never`.
  - Disables signcolumn, ruler, showcmd, statusline, and tabline in Firenvim.
  - Sets `sqlzoo*.txt` to SQL and GitHub/StackOverflow buffers to Markdown.
- wilder:
  - Initialized after a 250 ms timer.
  - Uses Python fuzzy command-line and search pipelines.
- vim-auto-save:
  - Enabled at startup with `g:auto_save = 1`.

## Filetype Detection

- `ftdetect/pdc.vim`: `*.pdc` files are Markdown.
- `ftdetect/snippets.vim`: `*.snippets` files use filetype `snippets`.

## Filetype Overrides

| File | Behavior |
| --- | --- |
| `after/ftplugin/cpp.vim` | `commentstring=// %s`; removes `o`/`r` from `formatoptions`; maps `<F9>` to Makefile-aware compile/run using `g++` or `clang++`, flags `-Wall -Wextra -std=c++17 -O2`, terminal split height 20. |
| `after/ftplugin/gitconfig.vim` | `commentstring=# %s`. |
| `after/ftplugin/javascript.vim` | Removes auto comment insertion on `o`, `O`, and Enter. |
| `after/ftplugin/json.vim` | Sets `foldlevel=0`; sets Tree-sitter foldexpr. |
| `after/ftplugin/lua.vim` | Removes auto comment insertion; `<F9>` runs current file through `luafile %` unless Makefile exists; sets Tree-sitter foldexpr. |
| `after/ftplugin/markdown.vim` | `concealcursor=c`, `synmaxcol=3000`, wraps lines; footnote mappings; Markdown code-block text objects; operators for adding list markers and hard line breaks. |
| `after/ftplugin/python.vim` | If `AsyncRun` exists, `<F9>` runs `AsyncRun python -u "%"` unless Makefile exists; no wrap; sidescroll settings; colorcolumn 100; 4-space indent; Tree-sitter foldexpr. |
| `after/ftplugin/qf.vim` | Resizes quickfix windows to between 5 and 15 lines. |
| `after/ftplugin/sql.vim` | `commentstring=-- %s`. |
| `after/ftplugin/tex.lua` | `textwidth=0`, wrap on, removes `t`, `a`, and `c` from local `formatoptions`. |
| `after/ftplugin/text.vim` | Clears `colorcolumn`. |
| `after/ftplugin/toml.vim` | Empty file. |
| `after/ftplugin/vim.vim` | Removes auto comment insertion; custom foldexpr/foldtext via `utils#VimFolds` and `utils#MyFoldText`; `keywordprg=:help`; `<F9>` sources current file unless Makefile exists. |
| `after/ftplugin/yaml.vim` | Disables syntax highlighting when file has more than 500 lines. |

## Custom Commands And Abbreviations

From `plugin/command.vim`:

- `:Redir {cmd}` captures command output into register `m`, opens a scratch tab, inserts captured lines, and restores register `m`.
- `:Edit {files...}` multi-edits glob-expanded file patterns.
- Command abbreviation `:edit` -> `:Edit`.
- Command abbreviation `:man` -> `:Man`.
- `:Datetime [timestamp]` prints current time or converts Unix timestamps, including millisecond/microsecond inputs.
- `:ToPDF` converts current Markdown file to PDF with Pandoc, XeLaTeX, Zenburn highlighting, TOC, and `resources/head.tex`; opens the PDF on macOS/Windows.
- `:[range]JSONFormat` filters selected lines through `python -m json.tool`.
- `:StartVlime` starts the VLime Common Lisp backend when VLime is available.

From `plugin/abbrev.vim`:

- Insert abbreviation `reqire` -> `require`.
- Insert abbreviation `serveral` -> `several`.

Other command-line abbreviations:

- `:git` -> `:Git` when fugitive config loads.

From `plugin/log-autocmds.vim`:

- `:LogAutocmds` toggles logging of many autocmd events to `/tmp/vim_log_autocommands`.

## Utility Functions

Lua utilities in `lua/utils.lua`:

- `executable(name)`
- `has(feature)`
- `may_create_dir(dir)`
- `rand_int(low, high)`
- `rand_element(seq)`
- `add_pack(name)`

Vimscript utilities in `autoload/utils.vim`:

- `utils#Cabbrev(key, value)`
- `utils#SynGroup()`
- `utils#HasColorscheme(name)`
- `utils#VimFolds(lnum)`
- `utils#MyFoldText()`
- `utils#ToggleCursorCol()`
- `utils#SwitchLine(src_line_idx, direction)`
- `utils#MoveSelection(direction)`
- `utils#Get_titlestr()`
- `utils#iso_time(timestamp)`
- `utils#Inside_git_repo()`
- `utils#GetGitBranch()`
- `utils#CaptureCommandOutput(command)`
- `utils#MultiEdit(patterns)`

Buffer helper:

- `buf_utils#GoToBuffer(count, direction)`: count-aware buffer navigation used by `gb` and `gB`.

Text objects:

- `text_obj#URL()`: selects URL under cursor, using `vim-highlighturl` pattern when available.
- `text_obj#MdCodeBlock(type)`: Markdown fenced-code-block text object.
- `text_obj#Buffer()`: whole-buffer linewise text object.

## Key Bindings

Leader is comma: `<leader> = ,`.

### Global Mappings

| Mode | Key | Action |
| --- | --- | --- |
| normal, visual | `;` | Enter command-line mode as `:`. |
| insert | `<C-u>` | Uppercase word under cursor. |
| insert | `<C-t>` | Title-case current word. |
| normal | `<leader>p` | Paste non-linewise text below current line. |
| normal | `<leader>P` | Paste non-linewise text above current line. |
| normal | `<leader>w` | Save/update current buffer. |
| normal | `<leader>q` | Save if modified and quit current window. |
| normal | `<leader>Q` | Force quit all Neovim buffers/windows. |
| normal | `[l` / `]l` | Previous/next location-list item. |
| normal | `[L` / `]L` | First/last location-list item. |
| normal | `[q` / `]q` | Previous/next quickfix item. |
| normal | `[Q` / `]Q` | First/last quickfix item. |
| normal | `\x` | Close location and quickfix lists. |
| normal | `\d` | Delete current buffer without closing window. |
| normal | `<space>o` | Insert blank line below without moving cursor; count-aware. |
| normal | `<space>O` | Insert blank line above without moving cursor; count-aware. |
| normal | `j` / `k` | Move by display line when no count, otherwise physical line. |
| normal | `^` / `0` | Move to display-line first nonblank/start. |
| visual | `$` | Move to `g_`, excluding trailing whitespace. |
| normal, visual | `H` | Move to first nonblank character. |
| normal, visual | `L` | Move to last nonblank character. |
| visual | `<` / `>` | Shift and reselect visual area. |
| normal | `<leader>ev` | Open `$MYVIMRC` in a new tab and set tab cwd. |
| normal | `<leader>sv` | Save/source `$MYVIMRC`, then notify. |
| normal | `<leader>v` | Reselect last pasted area. |
| normal | `/` | Start very-magic search with `/\v`. |
| normal | `<leader>cd` | Change local cwd to current file directory and print cwd. |
| terminal | `<Esc>` | Leave terminal mode. |
| normal | `<F11>` | Toggle spell checking. |
| insert | `<F11>` | Toggle spell checking without leaving insert mode. |
| normal | `<F9>` | Run `:make` if Makefile exists; otherwise warn unless filetype overrides. |
| normal | `c`, `C`, `cc` | Change using black-hole register. |
| visual | `c` | Change using black-hole register. |
| normal | `<leader><space>` | Run `:StripTrailingWhitespace`. |
| normal | `<leader>st` | Show syntax group at cursor. |
| normal | `<leader>y` | Yank entire buffer. |
| normal | `<leader>cl` | Toggle cursor column. |
| normal | `<A-k>` / `<A-j>` | Move current line up/down. |
| visual | `<A-k>` / `<A-j>` | Move visual-line selection up/down. |
| visual | `p` | Replace selection with register text without overwriting register. |
| normal | `gb` | Next buffer, or jump to counted buffer number. |
| normal | `gB` | Previous buffer. |
| normal | `<Left>` / `<Right>` / `<Up>` / `<Down>` | Move to left/right/up/down window. |
| visual, operator | `iu` | URL text object. |
| visual, operator | `iB` | Whole-buffer text object. |
| normal | `J` | Join lines without moving cursor. |
| normal | `gJ` | Join lines without moving cursor. |
| insert | `,`, `.`, `!`, `?`, `;`, `:` | Insert punctuation and break undo sequence with `<C-g>u`. |
| insert | `<A-;>` | Append semicolon at end of current line and return to insert position. |
| insert | `<C-A>` / `<C-E>` | Go to beginning/end of line. |
| command | `<C-A>` | Go to beginning of command line. |
| insert | `<C-D>` | Delete character to the right. |
| normal | `<leader>cb` | Blink cursor column/line several times. |

### Plugin Mappings

| Mode | Key | Source | Action |
| --- | --- | --- | --- |
| normal | `<leader>ff` | LeaderF | Search files in popup. |
| normal | `<leader>fg` | LeaderF | Ripgrep project in popup. |
| normal | `<leader>fh` | LeaderF | Search help. |
| normal | `<leader>ft` | LeaderF | Search current-buffer tags. |
| normal | `<leader>fb` | LeaderF | Switch buffers. |
| normal | `<leader>fr` | LeaderF | Search MRU files with absolute paths. |
| LeaderF prompt | `<C-J>` / `<C-K>` | LeaderF | Move to next/previous prompt result. |
| normal, visual | `<leader>ob` | open-browser, macOS/Windows only | Open URL/search target in browser. |
| normal | `<Space>t` | Vista | Toggle Vista tag sidebar. |
| normal | `<Space>u` | Mundo | Toggle undo tree. |
| Markdown normal | `<leader>x` | Grammarous, macOS only | Close grammar info window. |
| Markdown normal | `<C-n>` | Grammarous, macOS only | Next grammar error. |
| Markdown normal | `<C-p>` | Grammarous, macOS only | Previous grammar error. |
| normal | `ga` | unicode.vim | Unicode character info. |
| normal, operator | `s` | vim-sandwich setup | Mapped to `<Nop>` so sandwich can own `s` behavior. |
| TeX normal | `<F9>` | vimtex | Compile via vimtex unless Makefile exists. |
| normal | `<leader>dp` | nvim-gdb | Start Python PDB with `python -m pdb %`. |
| normal | `<leader>zn` | zk-nvim | New zk note. |
| normal | `<leader>zo` | zk-nvim | Open/search zk notes. |
| normal | `<leader>zt` | zk-nvim | Search zk tags. |
| normal | `<leader>zb` | zk-nvim | Show backlinks. |
| normal | `<leader>zl` | zk-nvim | Show links. |
| normal | `<leader>-` | yazi.nvim | Open Yazi at current file. |
| normal | `<leader>cw` | yazi.nvim | Open Yazi in Neovim cwd. |
| normal | `<C-Up>` | yazi.nvim | Resume/toggle last Yazi session. |
| Yazi UI | `<F1>` | yazi.nvim | Show Yazi help. |
| normal | `<space>s` | nvim-tree | Toggle NvimTree. |
| normal | `n` / `N` | hlslens | Next/previous search result, centered, with hlslens. |
| normal | `*` / `#` | hlslens | Search word under cursor and start hlslens. |
| normal, visual, operator | `f` | hop.nvim | Two-character Hop jump. |
| normal | `<leader>gs` | fugitive | `:Git` status. |
| normal | `<leader>gw` | fugitive | `:Gwrite` add/write. |
| normal | `<leader>gc` | fugitive | `:Git commit`. |
| normal | `<leader>gd` | fugitive | `:Gdiffsplit`. |
| normal | `<leader>gpl` | fugitive | `:Git pull`. |
| normal | `<leader>gpu` | fugitive | Open terminal split and run `git push`. |
| normal, visual | `<leader>gl` | gitlinker | Get permalink for current buffer/range. |
| normal | `<leader>gb` | gitlinker | Open repository URL in browser. |
| normal | `]c` / `[c` | gitsigns | Next/previous hunk, preserving diff-mode behavior. |
| normal | `<leader>hp` | gitsigns | Preview hunk. |
| normal | `<leader>hb` | gitsigns | Blame current line with full details. |
| normal | `[y` | yanky.nvim | Cycle yank history forward after paste. |
| normal | `]y` | yanky.nvim | Cycle yank history backward after paste. |
| insert | `<Tab>` / `<S-Tab>` | nvim-cmp | Next/previous completion item when menu is visible. |
| insert | `<CR>` | nvim-cmp | Confirm completion, selecting first item if needed. |
| insert | `<C-e>` | nvim-cmp | Abort completion. |
| insert | `<Esc>` | nvim-cmp | Close completion menu. |
| insert | `<C-d>` / `<C-f>` | nvim-cmp | Scroll completion docs. |
| insert/snippet | `<C-j>` | UltiSnips | Expand snippet or jump forward. |
| insert/snippet | `<C-k>` | UltiSnips | Jump backward. |
| command/search | `<Tab>` / `<S-Tab>` | wilder.nvim | Next/previous cmdline completion item. |
| command/search | `<C-y>` / `<C-e>` | wilder.nvim | Accept/reject cmdline completion. |

### LSP Buffer Mappings

See the LSP section above. These mappings are buffer-local and only exist after an LSP server attaches: `gd`, `<C-]>`, `K`, `<C-k>`, `<space>rn`, `gr`, `[d`, `]d`, `<space>qw`, `<space>qb`, `<space>ca`, `<space>wa`, `<space>wr`, `<space>wl`, and sometimes `<space>f`.

### Filetype Mappings

| Filetype | Mode | Key | Action |
| --- | --- | --- | --- |
| C++ | normal | `<F9>` | Makefile-aware compile/run current C++ file. |
| Lua | normal | `<F9>` | Makefile-aware `luafile %`. |
| Python | normal | `<F9>` | Makefile-aware `AsyncRun python -u "%"` if `AsyncRun` exists. |
| Vimscript | normal | `<F9>` | Makefile-aware `source %`. |
| TeX | normal | `<F9>` | Makefile-aware vimtex compile. |
| Markdown | normal, insert | `^^` | Insert Markdown footnote through `vim-markdownfootnotes`, if command exists. |
| Markdown | insert, normal | `@@` | Return from footnote through plugin mapping. |
| Markdown | visual, operator | `ic` | Inner fenced code block text object. |
| Markdown | visual, operator | `ac` | Around fenced code block text object. |
| Markdown | normal, visual | `+` | Add unordered-list marker to motion/range. |
| Markdown | normal, visual | `\` | Add hard line break backslash to motion/range. |

### GUI Mappings

From `ginit.vim`:

| Mode | Key | Action |
| --- | --- | --- |
| insert | `<S-Insert>` | Paste from `+` register. |
| command | `<S-Insert>` | Paste from `+` register. |
| normal | `<C-6>` | Switch to alternate buffer with `<C-^>`. |

## GUI Config

`ginit.vim`:

- nvim-qt:
  - Disables GUI tabline and popupmenu.
  - `GuiLinespace 2`.
  - `GuiFont! Hack NF:h10:l`.
- FVim:
  - `termguicolors`, colorscheme `gruvbox8_hard`, font `Hack NF:h13`.
  - Smooth cursor movement/blink, no background composition, opacity 1.0, custom title bar.
  - Font antialias/autohint/full hinting/subpixel/ligatures enabled.
  - Normal font weight 100, bold 700.
  - Popup menu disabled.
- Neovide:
  - Font `Hack NF:h10`.
  - Transparency 1.0.
  - Cursor animation length 0.1, trail size 0.3, no VFX mode.

## Snippets

Custom snippets live in `my_snippets/` and are loaded by UltiSnips.

- `all.snippets`: `ltx` -> `LaTeX`, `arw` -> `-->`.
- `cpp.snippets`: bare C++ template; include directives; vector/matrix/queue printers; `cout`; random vector generator; standard container aliases; `for`, `if`, `ifelse`; solution object helper.
- `markdown.snippets`: keyboard tags, front matter with current timestamp, `<!--more-->`, centered image HTML, font/link/details blocks, generated headings `h1`-`h6`, quote marks, info/warn/error/success boxes, `tl;dr`.
- `python.snippets`: file header, print format helper, `import as`, `main()`, `solution = Solution()`.
- `snippets.snippets`: UltiSnips snippet-definition template.
- `tex.snippets`: `\usepackage`, environment, equation, display math, inline math.
- `vim.snippets`: Vim function and augroup templates.

Spell additions:

- `spell/en.utf-8.add` contains 469 custom accepted words.

## Markdown To PDF Support

`:ToPDF` depends on:

- `pandoc`
- `xelatex`
- `resources/head.tex`

The LaTeX header:

- Sets geometry top 2 cm, bottom 1.5 cm, left/right 2 cm.
- Loads `fancyvrb`, `newverbs`, `xcolor`, `hyperref`, `tcolorbox`, and `enumitem`.
- Adds gray background for inline code.
- Replaces quote environment with a styled `tcolorbox`.
- Starts a new page after table of contents.
- Extends itemize/enumerate nesting to 9 levels.

## External Dependencies To Install On Fedora

For behavior closest to this config, install or provide these executables:

- Required or strongly expected: `nvim`, `git`, `python3`, `pip`, `node`, `npm`, `rg`.
- Python packages: `pynvim`, `python-lsp-server[all]`, `python-lsp-isort`, `pylsp-mypy`, `python-lsp-black`, `pylint`, `black`, `isort`.
- Language servers: `pylsp`, `ltex-ls`, `clangd`, `rust-analyzer`, `vim-language-server`, `bash-language-server`, `lua-language-server`.
- Optional feature gates: `ctags`, `latex`, `latexmk`, `xelatex`, `tmux`, `sbcl`, `pandoc`, `g++` or `clang++`, `trash`, `yazi`.
- Clipboard provider for `unnamedplus`: usually `wl-clipboard` on Wayland or `xclip`/`xsel` on X11.
- A Nerd Font such as `Hack NF` or `Iosevka Nerd Font` for icons.
- GitHub Copilot also needs Node.js and authentication with `:Copilot`.

Fedora package names vary by release, but the config logic only checks executable names. Codex should verify executables with `command -v` after installing dependencies.

## Recreation Checklist For Codex

1. Copy this local config tree to Fedora as `~/.config/nvim`, preserving `lazy-lock.json`, `my_snippets/`, `spell/`, `resources/`, and untracked local files.
2. Install Neovim 0.10.x or newer. `init.lua` expects `0.10.2`, but the version warning block is currently commented out.
3. Install the external dependencies listed above.
4. Start Neovim and let `lazy.nvim` install plugins.
5. Run `:Lazy sync` if plugins do not install automatically.
6. Run `:checkhealth`, remembering that `lua/config/health-filter.lua` suppresses warnings.
7. Confirm `:echo mapleader` returns `,`.
8. Confirm `:Lazy` sees the plugin specs from `lua/plugin_specs.lua`.
9. On Fedora, expect Linux-only plugin behavior and macOS-only plugin omissions exactly as described above.
