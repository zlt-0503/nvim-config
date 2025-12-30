# nvim-config

A modern Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

## Features

- **Plugin Manager**: lazy.nvim for fast and efficient plugin management
- **Modern UI**: Beautiful color scheme with Tokyo Night theme
- **File Explorer**: nvim-tree for easy file navigation
- **Fuzzy Finder**: Telescope for fast file and text searching
- **Syntax Highlighting**: Tree-sitter for advanced syntax highlighting
- **Status Line**: Lualine for an informative status bar
- **Auto Pairs**: Automatic bracket and quote pairing
- **Smart Comments**: Easy code commenting with Comment.nvim

## Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) for icons (optional but recommended)
- ripgrep (for Telescope live_grep)
- Node.js (for some plugins and Tree-sitter)

## Installation

### 1. Backup your existing Neovim configuration

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### 2. Clone this repository

```bash
git clone https://github.com/zlt-0503/nvim-config.git ~/.config/nvim
```

### 3. Start Neovim

```bash
nvim
```

lazy.nvim will automatically install itself and all configured plugins on first launch.

## Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── lua/
│   ├── core/               # Core Neovim settings
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # Key mappings
│   │   └── autocmds.lua    # Auto commands
│   └── plugins/            # Plugin configurations
│       ├── colorscheme.lua # Color scheme
│       ├── nvim-tree.lua   # File explorer
│       ├── telescope.lua   # Fuzzy finder
│       ├── treesitter.lua  # Syntax highlighting
│       ├── autopairs.lua   # Auto pairs
│       ├── comment.lua     # Comments
│       ├── lualine.lua     # Status line
│       └── bufferline.lua  # Buffer line
└── .gitignore
```

## Key Mappings

Leader key is set to `<Space>`.

### General

- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>nh` - Clear search highlights

### File Explorer (nvim-tree)

- `<leader>ee` - Toggle file explorer
- `<leader>ef` - Toggle file explorer on current file
- `<leader>ec` - Collapse file explorer
- `<leader>er` - Refresh file explorer

### Fuzzy Finder (Telescope)

- `<leader>ff` - Find files
- `<leader>fg` - Find text (live grep)
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help
- `<leader>fr` - Find recent files

### Window Management

- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split

### Tab Management

- `<leader>to` - Open new tab
- `<leader>tx` - Close current tab
- `<leader>tn` - Go to next tab
- `<leader>tp` - Go to previous tab
- `<leader>tf` - Open current buffer in new tab

### Buffer Navigation

- `Shift + h` - Previous buffer
- `Shift + l` - Next buffer

### Code Editing

- `gcc` - Toggle comment on current line
- `gc` - Toggle comment (in visual mode)
- `J` - Move line down (in visual mode)
- `K` - Move line up (in visual mode)

## Adding New Plugins

To add a new plugin, create a new file in `lua/plugins/` directory:

```lua
-- lua/plugins/your-plugin.lua
return {
  "username/plugin-name",
  config = function()
    -- Plugin configuration here
  end,
}
```

lazy.nvim will automatically detect and load the new plugin on next restart.

## Customization

- Edit `lua/core/options.lua` to modify Neovim options
- Edit `lua/core/keymaps.lua` to customize key mappings
- Edit plugin configuration files in `lua/plugins/` to customize plugin behavior

## Updating Plugins

Plugins can be updated using lazy.nvim's built-in commands:

- `:Lazy sync` - Update all plugins
- `:Lazy update` - Update all plugins without removing unused ones
- `:Lazy clean` - Remove unused plugins

## Troubleshooting

If you encounter issues:

1. Check Neovim version: `nvim --version` (should be >= 0.9.0)
2. Run `:checkhealth` in Neovim to diagnose issues
3. Clean and reinstall plugins: `:Lazy clean` then `:Lazy sync`

## License

This configuration is free to use and modify.