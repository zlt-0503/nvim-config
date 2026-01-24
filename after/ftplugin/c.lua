-- C filetype plugin
-- Enhanced support for C files, including kernel source trees

-- Function to detect if we're in a kernel source tree
local function is_kernel_source()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.expand("%:p:h")
  
  -- Check for common kernel indicators in the file path or parent directories
  local kernel_indicators = {
    "/kernel/",
    "/linux/",
    "/arch/",
    "Kconfig",
    "Kbuild",
  }
  
  -- Check if path contains kernel indicators
  for _, indicator in ipairs(kernel_indicators) do
    if current_file:find(indicator) or current_dir:find(indicator) then
      return true
    end
  end
  
  -- Check for kernel-specific files in parent directories
  local search_dir = current_dir
  for _ = 1, 5 do  -- Search up to 5 levels up
    local kconfig = search_dir .. "/Kconfig"
    local kbuild = search_dir .. "/Kbuild"
    local makefile = search_dir .. "/Makefile"
    
    if vim.fn.filereadable(kconfig) == 1 or vim.fn.filereadable(kbuild) == 1 then
      return true
    end
    
    -- Check if Makefile contains kernel-specific patterns
    if vim.fn.filereadable(makefile) == 1 then
      local ok, makefile_lines = pcall(vim.fn.readfile, makefile, "", 50)
      if ok then
        local makefile_content = table.concat(makefile_lines, "\n")
        -- Check for kernel-specific patterns
        if makefile_content:match("KERNELRELEASE") or 
           makefile_content:match("obj%-[my]") or
           makefile_content:match("vmlinux") then
          return true
        end
      end
    end
    
    -- Move up one directory
    local parent = vim.fn.fnamemodify(search_dir, ":h")
    if parent == search_dir then
      break  -- Reached root
    end
    search_dir = parent
  end
  
  return false
end

-- Configure diagnostics based on context
if is_kernel_source() then
  -- For kernel source files, reduce diagnostic noise
  -- Keep diagnostics available but less intrusive
  vim.diagnostic.config({
    virtual_text = false,  -- Disable inline error messages
    signs = true,          -- Keep gutter signs
    underline = false,     -- Disable underlining
    update_in_insert = false,
    severity_sort = true,
  }, vim.api.nvim_get_current_buf())
  
  -- Optionally show a message
  vim.notify("Kernel source detected - diagnostics reduced", vim.log.levels.INFO)
end

-- Set up better indentation for C code
vim.opt_local.cindent = true
vim.opt_local.cinoptions = ":0,l1,t0,g0,(0"

-- Use tabs for kernel code (follows Linux kernel coding style)
if is_kernel_source() then
  vim.opt_local.expandtab = false
  vim.opt_local.tabstop = 8
  vim.opt_local.shiftwidth = 8
  vim.opt_local.softtabstop = 8
end
