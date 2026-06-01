vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4

vim.opt_local.formatoptions:remove({ "o", "r" })

vim.keymap.set("n", "<F9>", function()
  NvimConfig.make_or_run(function()
    if vim.fn.executable("go") ~= 1 then
      vim.notify("go executable not found.", vim.log.levels.WARN, { title = "nvim-config" })
      return
    end

    vim.cmd("update")
    if vim.fn.filereadable("go.mod") == 1 then
      vim.cmd("GoRun")
    else
      vim.cmd("!go run " .. vim.fn.shellescape(vim.fn.expand("%:p")))
    end
  end)
end, { buffer = true, silent = true, desc = "make or run Go file" })
