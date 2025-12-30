-- Git Integration Plugins
return {
  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.plugins.config.git").gitsigns()
    end,
  },

  -- Neogit - Magit-like git interface
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      require("config.plugins.config.git").neogit()
    end,
  },

  -- Diffview for viewing diffs
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    config = function()
      require("config.plugins.config.git").diffview()
    end,
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gl", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
