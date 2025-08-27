vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.relativenumber = false
    vim.opt.number = false
  end,
})
