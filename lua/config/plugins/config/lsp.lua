local M = {}

function M.mason()
  require("mason").setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

function M.setup()
  local mason_lspconfig = require("mason-lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  -- Enhanced capabilities for autocompletion
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- LSP keymaps (set up via LspAttach autocmd for Neovim 0.11+)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "K", vim.lsp.buf.hover, "Hover documentation")
      map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("n", "gr", vim.lsp.buf.references, "Go to references")
      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Format buffer")
      map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostics")
      map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
  })

  -- Setup mason-lspconfig (Neovim 0.11+ compatible)
  -- automatic_enable = true uses vim.lsp.enable() to automatically enable installed servers
  mason_lspconfig.setup({
    ensure_installed = {
      "clangd",        -- C/C++
      "gopls",         -- Go
      "rust_analyzer", -- Rust
      "lua_ls",        -- Lua
      "texlab",        -- LaTeX
    },
    automatic_installation = true,
    automatic_enable = true,
  })

  -- Configure LSP servers using vim.lsp.config (Neovim 0.11+ API)
  -- Default configuration for all servers
  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  -- Clangd specific config
  vim.lsp.config("clangd", {
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
      "--query-driver=/usr/bin/*-gcc*,/usr/bin/clang*,/usr/bin/g++*",  -- Allow querying common compiler paths
      "--compile-commands-dir=.",  -- Look for compile_commands.json
    },
  })

  -- Lua LS specific config
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  -- Rust analyzer specific config
  vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  })

  -- Go specific config
  vim.lsp.config("gopls", {
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  })

  -- Diagnostic UI configuration
  -- Disabled virtual_text by default to reduce noise, especially for complex projects
  -- Use <leader>d to show diagnostics in a floating window
  vim.diagnostic.config({
    virtual_text = false,  -- Disable inline diagnostic messages
    signs = true,          -- Show signs in the gutter
    underline = true,      -- Underline problematic code
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
  })
end

function M.treesitter()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "c",
      "cpp",
      "go",
      "rust",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "bash",
      "json",
      "yaml",
      "toml",
      "latex",
      "bibtex",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  })
end

function M.cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
end

function M.conform()
  require("conform").setup({
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      go = { "gofumpt", "goimports" },
      rust = { "rustfmt" },
      lua = { "stylua" },
      latex = { "latexindent" },
    },
    -- Disabled automatic formatting on save
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
  })
end

function M.lint()
  local lint = require("lint")

  lint.linters_by_ft = {
    -- Removed clang-tidy for C/C++ as it's not available
    -- c = { "clang-tidy" },
    -- cpp = { "clang-tidy" },
    go = { "golangci-lint" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
      lint.try_lint()
    end,
  })
end

function M.clangd_extensions()
  require("clangd_extensions").setup({
    inlay_hints = {
      inline = true,
    },
    ast = {
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
    },
  })
end

return M
