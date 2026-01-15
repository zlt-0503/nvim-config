-- Assembly filetype plugin
-- Enhanced support for ARM64 and other assembly files

-- Set up folding based on labels and sections
-- Note: TreeSitter doesn't have a reliable parser for all assembly dialects,
-- so we use marker-based folding instead
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldmarker = "{{{,}}}"
vim.opt_local.foldenable = false -- Don't fold by default

-- Better syntax highlighting for assembly
-- Use Vim's built-in asm syntax which supports comments and basic highlighting
vim.opt_local.syntax = "asm"

-- Use tabs for assembly (common convention)
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8

-- Enable search for label definitions
-- This helps with gd (go to definition) for labels
vim.opt_local.include = [[\v^\s*\.?\w+:]]
vim.opt_local.includeexpr = ""

-- Set commentstring for commenting assembly
-- ARM64 assembly typically uses @ or // for comments
-- GNU AS also supports # and /* */
vim.opt_local.commentstring = "@ %s"  -- ARM assembly convention
vim.opt_local.comments = "://,@,:#,s:/*,m:*,e:*/"

-- Custom aerial configuration for assembly files
-- Note: Aerial doesn't support assembly files well without LSP or treesitter
-- We disable it and rely on telescope/grep for symbol search instead
vim.b.aerial = {
  -- Disable automatic attachment for assembly files
  -- Use <leader>fs (telescope lsp_document_symbols) or grep for symbol search
  attach = false,
  -- You can still manually open aerial, but it won't show symbols
  backends = {},
}

-- Custom function to jump to label definition
local function goto_asm_label()
  local word = vim.fn.expand("<cword>")
  -- Remove trailing colon if present
  word = word:gsub(":$", "")
  
  -- Search for label definition: "word:" at the beginning of a line (possibly with whitespace)
  local pattern = [[\v^\s*]] .. vim.fn.escape(word, "\\") .. [[:]]
  
  -- Try to find in current file first
  local current_pos = vim.fn.getcurpos()
  vim.cmd("normal! gg")
  
  local found = vim.fn.search(pattern, "W")
  if found == 0 then
    -- Restore position if not found in current file
    vim.fn.setpos(".", current_pos)
    
    -- Try to search in other assembly files in the project
    -- Use telescope if available for better UX
    if pcall(require, "telescope.builtin") then
      require("telescope.builtin").grep_string({
        search = "^\\s*" .. word .. ":",
        use_regex = true,
        prompt_title = "Find Label: " .. word,
      })
    else
      -- Fallback to vimgrep
      local search_pattern = "^\\s*" .. vim.fn.escape(word, "\\") .. ":"
      vim.cmd("silent! vimgrep /" .. search_pattern .. "/gj **/*.s **/*.S **/*.asm")
      local qflist = vim.fn.getqflist()
      if #qflist > 0 then
        vim.cmd("copen")
      else
        vim.notify("Label '" .. word .. "' not found", vim.log.levels.WARN)
      end
    end
  else
    -- Add to jump list
    vim.cmd("normal! m'")
  end
end

-- Custom function to find label references
local function find_asm_label_refs()
  local word = vim.fn.expand("<cword>")
  -- Remove trailing colon if present
  word = word:gsub(":$", "")
  
  -- Use telescope or quickfix to show all references
  if pcall(require, "telescope.builtin") then
    require("telescope.builtin").grep_string({
      search = word,
      use_regex = false,
    })
  else
    vim.cmd("vimgrep /" .. vim.fn.escape(word, "/\\") .. "/gj %")
    vim.cmd("copen")
  end
end

-- Key mappings for assembly navigation
local opts = { buffer = true, silent = true, noremap = true }

-- Override gd for assembly label jumping
vim.keymap.set("n", "gd", goto_asm_label, vim.tbl_extend("force", opts, { desc = "Go to label definition" }))

-- Find all references to current label
vim.keymap.set("n", "gr", find_asm_label_refs, vim.tbl_extend("force", opts, { desc = "Find label references" }))

-- Quick jump to next/previous label
vim.keymap.set("n", "]]", [[/^\s*\w\+:\zs<CR>]], vim.tbl_extend("force", opts, { desc = "Next label" }))
vim.keymap.set("n", "[[", [[?^\s*\w\+:\zs<CR>]], vim.tbl_extend("force", opts, { desc = "Previous label" }))

-- Quick jump to next/previous section (starting with .)
vim.keymap.set("n", "]s", [[/^\s*\.\w\+\zs<CR>]], vim.tbl_extend("force", opts, { desc = "Next section" }))
vim.keymap.set("n", "[s", [[?^\s*\.\w\+\zs<CR>]], vim.tbl_extend("force", opts, { desc = "Previous section" }))

-- Alternative to aerial: Show all labels in current file using telescope/quickfix
local function show_labels()
  -- Pattern to match labels (word followed by colon at start of line)
  local label_pattern = [[^\s*\w\+:]]
  
  if pcall(require, "telescope.builtin") then
    require("telescope.builtin").grep_string({
      search = label_pattern,
      use_regex = true,
      prompt_title = "Assembly Labels",
      search_dirs = { vim.fn.expand("%:p") },
    })
  else
    -- Fallback to location list
    vim.cmd("silent! lvimgrep /" .. label_pattern .. "/gj %")
    vim.cmd("lopen")
  end
end

vim.keymap.set("n", "<leader>al", show_labels, vim.tbl_extend("force", opts, { desc = "Show all labels (assembly)" }))
