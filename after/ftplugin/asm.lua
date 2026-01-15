-- Assembly filetype plugin
-- Enhanced support for ARM64 and other assembly files

-- Set up folding based on labels and sections
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldenable = false -- Don't fold by default

-- Better syntax highlighting for assembly
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
vim.opt_local.commentstring = "// %s"  -- For ARM64 assembly
vim.opt_local.comments = "://,://!,:#"

-- Custom aerial configuration for assembly files
vim.b.aerial = {
  -- Disable if no backend is available for this file
  attach = false,
}

-- Custom function to jump to label definition
local function goto_asm_label()
  local word = vim.fn.expand("<cword>")
  -- Search for label definition: "word:" at the beginning of a line (possibly with whitespace)
  local pattern = [[\v^\s*]] .. vim.fn.escape(word, "\\") .. [[:]]
  
  -- Try to find in current file first
  local current_pos = vim.fn.getcurpos()
  vim.cmd("normal! gg")
  
  local found = vim.fn.search(pattern, "W")
  if found == 0 then
    -- Restore position if not found
    vim.fn.setpos(".", current_pos)
    vim.notify("Label '" .. word .. "' not found in current file", vim.log.levels.WARN)
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
