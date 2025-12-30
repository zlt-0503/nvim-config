local M = {}

function M.telescope()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

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

return M
