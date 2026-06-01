vim.opt_local.commentstring = "// %s"
vim.opt_local.expandtab = false
vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.textwidth = 80
vim.opt_local.cindent = true
vim.opt_local.colorcolumn = "80"

vim.opt_local.formatoptions:remove({ "o", "r" })

vim.keymap.set("n", "<F9>", function()
  NvimConfig.make_or_run(function()
    local src = vim.fn.shellescape(vim.fn.expand("%:p"))
    local out = vim.fn.shellescape(vim.fn.expand("%:p:r"))
    local compiler = vim.fn.executable("cc") == 1 and "cc" or "gcc"

    vim.cmd("update")
    vim.cmd("set splitbelow")
    vim.cmd("new")
    vim.cmd("resize 20")
    vim.cmd(("term %s -Wall -Wextra -O2 %s -o %s && %s"):format(compiler, src, out, out))
    vim.cmd("startinsert")
  end)
end, { buffer = true, silent = true, desc = "make or compile/run C file" })
