local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  local uv = vim.uv or vim.loop

  if not uv.fs_stat(lazypath) then
    local function clone(url)
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        url,
        "--branch=stable",
        lazypath,
      })
      return vim.v.shell_error == 0
    end

    -- Prefer SSH; fallback to HTTPS if SSH fails (e.g., no SSH key configured)
    if not clone("git@github.com:folke/lazy.nvim.git") then
      clone("https://github.com/folke/lazy.nvim.git")
    end
  end

  vim.opt.rtp:prepend(lazypath)
end

return M

