-- Auto-command to disable line numbers in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false         -- disable absolute line numbers
    vim.wo.relativenumber = false -- disable relative line numbers
  end,
})
