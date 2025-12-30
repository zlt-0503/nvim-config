-- UI Enhancement Plugins
return {
  -- File icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.plugins.config.ui").lualine()
    end,
  },

  -- Buffer line (tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.plugins.config.ui").bufferline()
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.plugins.config.ui").dashboard()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      require("config.plugins.config.ui").indent_blankline()
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("config.plugins.config.ui").notify()
    end,
  },

  -- UI for messages, cmdline, and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("config.plugins.config.ui").noice()
    end,
  },

  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.plugins.config.ui").whichkey()
    end,
  },
}
