vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = "100"

vim.opt_local.formatoptions:remove({ "o", "r" })

vim.keymap.set("n", "<F9>", function()
  NvimConfig.make_or_run(function()
    if vim.fn.executable("cargo") == 1 and vim.fn.filereadable("Cargo.toml") == 1 then
      vim.cmd("update")
      vim.opt_local.makeprg = "cargo run"
      vim.cmd("make")
      return
    end

    if vim.fn.executable("rustc") ~= 1 then
      vim.notify("rustc executable not found.", vim.log.levels.WARN, { title = "nvim-config" })
      return
    end

    local src = vim.fn.shellescape(vim.fn.expand("%:p"))
    local out = vim.fn.shellescape(vim.fn.expand("%:p:r"))
    vim.cmd("update")
    vim.cmd("set splitbelow")
    vim.cmd("new")
    vim.cmd("resize 20")
    vim.cmd(("term rustc %s -o %s && %s"):format(src, out, out))
    vim.cmd("startinsert")
  end)
end, { buffer = true, silent = true, desc = "make or run Rust target" })
