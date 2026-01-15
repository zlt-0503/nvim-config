-- Assembly filetype detection
-- Ensure various assembly file extensions are properly detected

vim.filetype.add({
  extension = {
    s = "asm",      -- GNU assembler (common for ARM64)
    S = "asm",      -- GNU assembler with C preprocessor
    asm = "asm",    -- Generic assembly
    inc = "asm",    -- Assembly include files
  },
  pattern = {
    -- Match files with .s or .S extension that might contain ARM assembly
    [".*%.s"] = "asm",
    [".*%.S"] = "asm",
  },
})
