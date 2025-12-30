-- Navigation and Search Plugins
return {
  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
    },
    config = function()
      require("config.plugins.config.navigation").telescope()
    end,
  },

  -- Yazi file manager integration
  {
    "mikavilpas/yazi.nvim",
    cmd = "Yazi",
    keys = {
      { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Yazi" },
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open Yazi in cwd" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.plugins.config.navigation").yazi()
    end,
  },

  -- Flash for quick navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
    config = function()
      require("config.plugins.config.navigation").flash()
    end,
  },
}
