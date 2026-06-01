vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

vim.opt_local.commentstring = "(* %s *)"
vim.opt_local.formatoptions:remove({ "o", "r" })

vim.keymap.set("n", "<F9>", function()
  NvimConfig.make_or_run(function()
    if vim.fn.executable("dune") == 1 and (vim.fn.filereadable("dune-project") == 1 or vim.fn.filereadable("dune") == 1) then
      vim.cmd("update")
      vim.opt_local.makeprg = "dune build"
      vim.cmd("make")
      return
    end

    if vim.fn.executable("ocamlc") ~= 1 then
      vim.notify("ocamlc executable not found.", vim.log.levels.WARN, { title = "nvim-config" })
      return
    end

    local src = vim.fn.shellescape(vim.fn.expand("%:p"))
    local out = vim.fn.shellescape(vim.fn.expand("%:p:r"))
    vim.cmd("update")
    vim.cmd("set splitbelow")
    vim.cmd("new")
    vim.cmd("resize 20")
    vim.cmd(("term ocamlc %s -o %s && %s"):format(src, out, out))
    vim.cmd("startinsert")
  end)
end, { buffer = true, silent = true, desc = "make or build OCaml target" })
