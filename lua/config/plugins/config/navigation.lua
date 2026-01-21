local M = {}

function M.nvimtree()
  -- Disable netrw at the very start (recommended by nvim-tree)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 30,
      side = "left",
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        show = {
          git = true,
          folder = true,
          file = true,
          folder_arrow = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$" },
    },
    git = {
      enable = true,
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
  })
end

function M.telescope()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  -- Custom buffer previewer to avoid ft_to_lang error
  local function buffer_previewer_maker(filepath, bufnr, opts)
    opts = opts or {}

    filepath = vim.fn.expand(filepath)
    require("telescope.previewers.utils").job_maker(
      { "cat", "--", filepath },
      bufnr,
      opts
    )
  end

  telescope.setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = "  ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<esc>"] = actions.close,
        },
        n = {
          ["q"] = actions.close,
        },
      },
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        "target/",
        "vendor/",
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      -- Use custom buffer previewer to avoid ft_to_lang compatibility issues
      buffer_previewer_maker = buffer_previewer_maker,
    },
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  -- Load extensions
  telescope.load_extension("fzf")
end

function M.yazi()
  require("yazi").setup({
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  })
end

function M.flash()
  require("flash").setup({
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
    },
    jump = {
      jumplist = true,
      pos = "start",
    },
    label = {
      uppercase = false,
      rainbow = {
        enabled = true,
      },
    },
    modes = {
      char = {
        enabled = true,
        jump_labels = true,
      },
    },
  })
end

function M.aerial()
  require("aerial").setup({
    -- For assembly, LSP backend works better than treesitter
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    layout = {
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 20,
      default_direction = "prefer_right",
      placement = "window",
    },
    attach_mode = "window",
    close_automatic_events = {},
    -- Disable for assembly files if no backend available
    disable_max_lines = 10000,
    disable_max_size = 2000000,
    ignore = {
      buftypes = "special",
      filetypes = {},
      wintypes = "special",
    },
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll",
      ["{}"] = "actions.prev",
      ["}}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["[]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["O"] = "actions.tree_toggle_recursive",
      ["zA"] = "actions.tree_toggle_recursive",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["L"] = "actions.tree_open_recursive",
      ["zO"] = "actions.tree_open_recursive",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
      ["H"] = "actions.tree_close_recursive",
      ["zC"] = "actions.tree_close_recursive",
      ["zR"] = "actions.tree_open_all",
      ["zM"] = "actions.tree_close_all",
      ["zx"] = "actions.tree_sync",
      ["zX"] = "actions.tree_sync_recursive",
    },
    -- Show icons for different symbol types
    icons = {},
    filter_kind = false,
    highlight_mode = "split_width",
    highlight_closest = true,
    highlight_on_hover = true,
    highlight_on_jump = 300,
    -- For assembly files, show labels and sections
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },
  })
end

function M.marks()
  require("marks").setup({
    default_mappings = true,
    builtin_marks = { ".", "<", ">", "^", "'", "`" },
    cyclic = true,
    force_write_shada = false,
    refresh_interval = 250,
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    excluded_filetypes = {},
    bookmark_0 = {
      sign = "⚑",
      virt_text = "bookmark",
      annotate = false,
    },
    mappings = {},
  })
end

return M
