local M = {}

-- Safe require: returns (ok, module_or_err)
function M.safe_require(mod)
  local ok, loaded = pcall(require, mod)
  if not ok then
    vim.schedule(function()
      vim.notify(("Failed to load module: %s\n%s"):format(mod, loaded), vim.log.levels.WARN)
    end)
  end
  return ok, loaded
end

return M

