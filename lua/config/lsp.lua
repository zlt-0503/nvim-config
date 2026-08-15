local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils")
local float_border = require("config.float-border")

-- set quickfix list from diagnostics in a certain buffer, not the whole workspace
local set_qflist = function(buf_num, severity)
  local diagnostics = nil
  diagnostics = diagnostic.get(buf_num, { severity = severity })

  local qf_items = diagnostic.toqflist(diagnostics)
  vim.fn.setqflist({}, ' ', { title = 'Diagnostics', items = qf_items })

  -- open quickfix by default
  vim.cmd[[copen]]
end

local custom_attach = function(client, bufnr)
  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
  map("n", "<C-]>", vim.lsp.buf.definition)
  map("n", "K", function()
    vim.lsp.buf.hover({ border = float_border.lsp })
  end)
  map("n", "<C-k>", function()
    vim.lsp.buf.signature_help({ border = float_border.lsp })
  end)
  map("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
  map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
  map("n", "[d", diagnostic.goto_prev, { desc = "previous diagnostic" })
  map("n", "]d", diagnostic.goto_next, { desc = "next diagnostic" })
  -- this puts diagnostics from opened files to quickfix
  map("n", "<space>qw", diagnostic.setqflist, { desc = "put window diagnostics to qf" })
  -- this puts diagnostics from current buffer to quickfix
  map("n", "<space>qb", function() set_qflist(bufnr) end, { desc = "put buffer diagnostics to qf" })
  map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
  map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
  map("n", "<space>wl", function()
    inspect(vim.lsp.buf.list_workspace_folders())
  end, { desc = "list workspace folder" })

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<space>f", vim.lsp.buf.format, { desc = "format code" })
  end

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = float_border.lsp,
        source = "always", -- show source in diagnostic popup window
        prefix = " ",
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
          and #diagnostic.get() > 0
      then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end,
  })

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    api.nvim_create_autocmd("CursorHold" , {
      group = gid,
      buffer = bufnr,
      callback = function ()
        lsp.buf.document_highlight()
      end
    })

    api.nvim_create_autocmd("CursorMoved" , {
      group = gid,
      buffer = bufnr,
      callback = function ()
        lsp.buf.clear_references()
      end
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local enable_lsp = function(server, config)
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

if utils.executable("ltex-ls") then
  enable_lsp("ltex", {
    on_attach = custom_attach,
    cmd = { "ltex-ls" },
    filetypes = { "text", "plaintex", "tex", "markdown" },
    settings = {
      ltex = {
        language = "en"
      },
    },
    flags = { debounce_text_changes = 300 },
  })
end

if utils.executable("clangd") then
  enable_lsp("clangd", {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    cmd = {
      "clangd",
      "--background-index",
      "--completion-style=detailed",
      "--header-insertion=never",
      "--query-driver=/usr/bin/clang,/usr/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
    },
    root_markers = {
      "compile_commands.json",
      "compile_flags.txt",
      ".clangd",
      "Kbuild",
      "Kconfig",
      "Makefile",
      ".git"
    },
    flags = {
      debounce_text_changes = 500,
    },
  })
end

if utils.executable("gopls") then
  enable_lsp("gopls", {
    on_attach = custom_attach,
    capabilities = capabilities,
    settings = {
      gopls = {
        gofumpt = false,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  })
end

if utils.executable("rust-analyzer") then
  enable_lsp("rust_analyzer", {
    on_attach = custom_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
      },
    },
    flags = {
      debounce_text_changes = 500,
    },
  })
end

if utils.executable("ocamllsp") then
  enable_lsp("ocamllsp", {
    on_attach = custom_attach,
    capabilities = capabilities,
  })
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
  enable_lsp("vimls", {
    on_attach = custom_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  })
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
  enable_lsp("bashls", {
    on_attach = custom_attach,
    capabilities = capabilities,
  })
end

if utils.executable("lua-language-server") then
  -- settings for lua-language-server can be found on https://github.com/LuaLS/lua-language-server/wiki/Settings .
  enable_lsp("lua_ls", {
    on_attach = custom_attach,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
          library = {
            vim.env.VIMRUNTIME,
            fn.stdpath("config"),
          },
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
      },
    },
    capabilities = capabilities,
  })
end

-- global config for diagnostic
diagnostic.config {
  underline = false,
  virtual_text = false,
  signs = {
    text = {
      [diagnostic.severity.ERROR] = '🆇',
      [diagnostic.severity.WARN] = '⚠️',
      [diagnostic.severity.INFO] = 'ℹ️',
      [diagnostic.severity.HINT] = '',
    },
  },
  severity_sort = true,
}

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = float_border.lsp,
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(vim.lsp.handlers.signature_help, {
  border = float_border.lsp,
})
