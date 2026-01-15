-- Entry point: keep this file tiny.

-- Filetype detection for assembly files
vim.filetype.add({
  extension = {
    s = "asm",      -- GNU assembler (common for ARM64)
    S = "asm",      -- GNU assembler with C preprocessor
    asm = "asm",    -- Generic assembly
    inc = "asm",    -- Assembly include files
  },
})

require("config.core.globals")
require("config.core.options")
require("config.core.mappings")
require("config.core.autocmds")
require("config.plugins")

