local M = {}

function M.lualine()
  require("lualine").setup({
    options = {
      theme = "tokyonight",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

function M.bufferline()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
    },
  })
end

function M.dashboard()
  require("dashboard").setup({
    theme = "doom",
    config = {
      header = {
        "",
        "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
      },
      center = {
        { icon = "  ", desc = "Find File", key = "f", action = "Telescope find_files" },
        { icon = "  ", desc = "Recent Files", key = "r", action = "Telescope oldfiles" },
        { icon = "  ", desc = "Find Text", key = "g", action = "Telescope live_grep" },
        { icon = "  ", desc = "Config", key = "c", action = "edit ~/.config/nvim/init.lua" },
        { icon = "  ", desc = "Lazy", key = "l", action = "Lazy" },
        { icon = "  ", desc = "Quit", key = "q", action = "qa" },
      },
      footer = { "", "🚀 Ready to code!" },
    },
  })
end

function M.indent_blankline()
  require("ibl").setup({
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
  })
end

function M.notify()
  require("notify").setup({
    background_colour = "#000000",
    timeout = 3000,
    max_width = 80,
    stages = "fade_in_slide_out",
  })
  vim.notify = require("notify")
end

function M.noice()
  require("noice").setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  })
end

function M.whichkey()
  require("which-key").setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = true },
    },
    win = {
      border = "rounded",
    },
  })
end

return M
