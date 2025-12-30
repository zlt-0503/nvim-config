# Neovim Configuration

A modern, modular Neovim configuration optimized for **Fedora Linux**, **Alacritty**, and **Hyprland**.

## 📁 Project Structure

```
nvim-config/
├── init.lua                          # Entry point
├── lazy-lock.json                    # Plugin version lock file
└── lua/
    └── config/
        ├── core/                     # Core configuration
        │   ├── globals.lua          # Global variables (leader keys, providers)
        │   ├── options.lua          # Vim options
        │   ├── mappings.lua         # Key mappings
        │   └── autocmds.lua         # Auto commands
        ├── plugins/
        │   ├── init.lua             # Lazy.nvim setup
        │   ├── spec/                # Plugin specifications
        │   │   ├── base.lua         # Base plugins (theme, plenary)
        │   │   ├── ui.lua           # UI enhancement plugins
        │   │   ├── lsp.lua          # LSP, completion, formatting
        │   │   ├── navigation.lua   # Navigation and search
        │   │   ├── git.lua          # Git integration
        │   │   ├── terminal.lua     # Terminal management
        │   │   └── latex.lua        # LaTeX support
        │   └── config/              # Plugin configurations
        │       ├── base.lua         # Theme config
        │       ├── ui.lua           # UI plugins config
        │       ├── lsp.lua          # LSP/completion config
        │       ├── navigation.lua   # Navigation config
        │       ├── git.lua          # Git plugins config
        │       └── terminal.lua     # Terminal config
        └── utils/
            ├── init.lua             # Utility functions
            └── lazy.lua             # Lazy.nvim bootstrap
```

## 🔌 Plugins

### Base Plugins
| Plugin | Description | Repository |
|--------|-------------|------------|
| lazy.nvim | Plugin manager | https://github.com/folke/lazy.nvim |
| plenary.nvim | Lua utility library | https://github.com/nvim-lua/plenary.nvim |
| tokyonight.nvim | Color scheme | https://github.com/folke/tokyonight.nvim |

### UI Enhancement
| Plugin | Description | Repository |
|--------|-------------|------------|
| nvim-web-devicons | File icons | https://github.com/nvim-tree/nvim-web-devicons |
| lualine.nvim | Status line | https://github.com/nvim-lualine/lualine.nvim |
| bufferline.nvim | Buffer/tab line | https://github.com/akinsho/bufferline.nvim |
| dashboard-nvim | Start screen | https://github.com/nvimdev/dashboard-nvim |
| indent-blankline.nvim | Indent guides | https://github.com/lukas-reineke/indent-blankline.nvim |
| nvim-notify | Notifications | https://github.com/rcarriga/nvim-notify |
| noice.nvim | UI for messages/cmdline | https://github.com/folke/noice.nvim |
| nui.nvim | UI component library | https://github.com/MunifTanjim/nui.nvim |
| which-key.nvim | Keybinding hints | https://github.com/folke/which-key.nvim |

### LSP, Completion & Formatting
| Plugin | Description | Repository |
|--------|-------------|------------|
| nvim-lspconfig | LSP configuration | https://github.com/neovim/nvim-lspconfig |
| mason.nvim | LSP/DAP/Linter manager | https://github.com/williamboman/mason.nvim |
| mason-lspconfig.nvim | Mason-LSP bridge | https://github.com/williamboman/mason-lspconfig.nvim |
| nvim-treesitter | Syntax highlighting | https://github.com/nvim-treesitter/nvim-treesitter |
| nvim-cmp | Autocompletion | https://github.com/hrsh7th/nvim-cmp |
| cmp-nvim-lsp | LSP completion source | https://github.com/hrsh7th/cmp-nvim-lsp |
| cmp-buffer | Buffer completion source | https://github.com/hrsh7th/cmp-buffer |
| cmp-path | Path completion source | https://github.com/hrsh7th/cmp-path |
| LuaSnip | Snippet engine | https://github.com/L3MON4D3/LuaSnip |
| cmp_luasnip | Snippet completion source | https://github.com/saadparwaiz1/cmp_luasnip |
| friendly-snippets | Snippet collection | https://github.com/rafamadriz/friendly-snippets |
| conform.nvim | Formatting | https://github.com/stevearc/conform.nvim |
| nvim-lint | Linting | https://github.com/mfussenegger/nvim-lint |
| clangd_extensions.nvim | C/C++ LSP enhancements | https://github.com/p00f/clangd_extensions.nvim |

### Navigation & Search
| Plugin | Description | Repository |
|--------|-------------|------------|
| telescope.nvim | Fuzzy finder | https://github.com/nvim-telescope/telescope.nvim |
| telescope-fzf-native.nvim | FZF sorter for Telescope | https://github.com/nvim-telescope/telescope-fzf-native.nvim |
| yazi.nvim | Yazi file manager integration | https://github.com/mikavilpas/yazi.nvim |
| flash.nvim | Quick navigation | https://github.com/folke/flash.nvim |

### Git Integration
| Plugin | Description | Repository |
|--------|-------------|------------|
| gitsigns.nvim | Git signs in gutter | https://github.com/lewis6991/gitsigns.nvim |
| neogit | Git interface (like Magit) | https://github.com/NeogitOrg/neogit |
| diffview.nvim | Diff viewer | https://github.com/sindrets/diffview.nvim |
| lazygit.nvim | LazyGit integration | https://github.com/kdheepak/lazygit.nvim |

### Terminal
| Plugin | Description | Repository |
|--------|-------------|------------|
| toggleterm.nvim | Terminal management | https://github.com/akinsho/toggleterm.nvim |

### LaTeX
| Plugin | Description | Repository |
|--------|-------------|------------|
| vimtex | LaTeX support | https://github.com/lervag/vimtex |

## ⌨️ Key Mappings

**Leader key:** `<Space>`

### General
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>h` | Normal | Clear search highlight |
| `;` | Normal, Visual | Enter command mode (like `:`) |
| `<C-h/j/k/l>` | Normal | Window navigation |

### Telescope (Find)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fr` | Normal | Recent files |
| `<leader>fc` | Normal | Commands |
| `<leader>fd` | Normal | Diagnostics |
| `<leader>fs` | Normal | Document symbols |

### LSP
| Key | Mode | Description |
|-----|------|-------------|
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition |
| `K` | Normal | Hover documentation |
| `gi` | Normal | Go to implementation |
| `<C-k>` | Normal | Signature help |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code action |
| `gr` | Normal | Go to references |
| `<leader>f` | Normal | Format buffer |
| `<leader>d` | Normal | Show diagnostics |
| `[d` / `]d` | Normal | Previous/Next diagnostic |

### Git
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gg` | Normal | Open Neogit |
| `<leader>gl` | Normal | Open LazyGit |
| `<leader>gd` | Normal | Diffview Open |
| `<leader>gh` | Normal | File History |
| `<leader>gs` | Normal, Visual | Stage hunk |
| `<leader>gr` | Normal, Visual | Reset hunk |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gu` | Normal | Undo stage hunk |
| `<leader>gR` | Normal | Reset buffer |
| `<leader>gp` | Normal | Preview hunk |
| `<leader>gb` | Normal | Blame line |
| `<leader>gtb` | Normal | Toggle blame |
| `<leader>gtd` | Normal | Toggle deleted |
| `]c` / `[c` | Normal | Next/Previous hunk |

### Navigation
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | Normal | Open Yazi |
| `<leader>E` | Normal | Open Yazi in cwd |
| `s` | Normal, Visual, Operator | Flash jump |
| `S` | Normal, Visual, Operator | Flash Treesitter |
| `r` | Operator | Remote Flash |
| `R` | Operator, Visual | Treesitter Search |

### Terminal
| Key | Mode | Description |
|-----|------|-------------|
| `<C-\>` | Normal, Terminal | Toggle terminal |
| `<leader>tf` | Normal | Float terminal |
| `<leader>th` | Normal | Horizontal terminal |
| `<leader>tv` | Normal | Vertical terminal |
| `<Esc>` / `jk` | Terminal | Exit terminal mode |
| `<C-h/j/k/l>` | Terminal | Window navigation |

### LaTeX (VimTeX)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ll` | Normal | Compile LaTeX |
| `<leader>lv` | Normal | View PDF |
| `<leader>lc` | Normal | Clean build files |
| `<leader>lt` | Normal | Open TOC |

### Completion (Insert Mode)
| Key | Mode | Description |
|-----|------|-------------|
| `<C-Space>` | Insert | Trigger completion |
| `<C-e>` | Insert | Abort completion |
| `<CR>` | Insert | Confirm selection |
| `<Tab>` | Insert | Next item / expand snippet |
| `<S-Tab>` | Insert | Previous item |
| `<C-b>` / `<C-f>` | Insert | Scroll docs |

## 📦 External Dependencies

Before using this configuration, install the following dependencies on **Fedora**:

### Required
```bash
# Core tools
sudo dnf install -y neovim git curl unzip

# For Telescope
sudo dnf install -y fd-find ripgrep

# C/C++ toolchain
sudo dnf install -y gcc gcc-c++ clang clang-tools-extra cmake make

# For telescope-fzf-native
sudo dnf install -y fzf
```

### Language-Specific

```bash
# Go
sudo dnf install -y golang

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer clippy rustfmt

# Lua (for stylua)
cargo install stylua

# LaTeX
sudo dnf install -y texlive-scheme-full latexmk

# PDF viewer for VimTeX (choose one)
sudo dnf install -y zathura zathura-pdf-mupdf
# or: sudo dnf install -y okular
```

### Optional Tools

```bash
# Yazi file manager
cargo install yazi-fm yazi-cli

# LazyGit
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y lazygit

# Node.js (for some LSP servers)
sudo dnf install -y nodejs npm

# Python (for some tools)
sudo dnf install -y python3 python3-pip
```

### Mason-managed Tools

The following are installed automatically via Mason (`:Mason`):
- `clangd` - C/C++ LSP
- `gopls` - Go LSP
- `rust-analyzer` - Rust LSP
- `lua-language-server` - Lua LSP
- `texlab` - LaTeX LSP
- `clang-format` - C/C++ formatter
- `gofumpt`, `goimports` - Go formatters
- `golangci-lint` - Go linter
- `clang-tidy` - C/C++ linter

## 🚀 Installation

1. Backup your existing config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/zlt-0503/nvim-config ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```
   
   Lazy.nvim will automatically install all plugins on first launch.

4. Install LSP servers and tools:
   ```vim
   :Mason
   ```

5. Install Treesitter parsers:
   ```vim
   :TSUpdate
   ```

## 🎨 Theme

This configuration uses **Tokyo Night** with transparent background support, optimized for terminals like Alacritty with transparency enabled.

## 📝 Notes

- **Nerd Fonts Required**: Install a [Nerd Font](https://www.nerdfonts.com/) for icons to display correctly.
- **Clipboard**: Uses system clipboard (`unnamedplus`). Ensure `xclip` or `wl-clipboard` is installed:
  ```bash
  # For X11
  sudo dnf install -y xclip
  # For Wayland (Hyprland)
  sudo dnf install -y wl-clipboard
  ```
- **True Colors**: Requires a terminal with true color support (Alacritty supports this by default).

## 📄 License

MIT License
