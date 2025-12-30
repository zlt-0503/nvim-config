return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("config.plugins.config.base").theme()
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = true },
}
