-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    print "No LSP clients attached to current buffer"
  else
    for _, client in ipairs(clients) do
      print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
    end
  end
end, { desc = "Show LSP client info" })

-- Fixes folds not working properly on search or initial load
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
  pattern = "*",
  callback = function() vim.cmd "normal! zR" end,
})

-- Git-conflict auotcmd
vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand "<afile>")
    vim.keymap.set("n", "cww", function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end,
})

-- Apply treesitter only applies to file types supported by Treesitter
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   callback = function(ctx)
--     if vim.treesitter.foldexpr() ~= nil then
--       vim.wo[ctx.buf].foldmethod = "expr"
--       vim.wo[ctx.buf].foldexpr = "v:lua.vim.treesitter.foldexpr()"
--     end
--   end,
-- })

-- Auto save using conform
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   -- pattern = "*",
--   callback = function(args)
--     require("conform").format { bufnr = args.buf }
--   end,
-- })

-- Autocommand to set keymaps when a server attaches
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
--   callback = function(ev)
--     local map = vim.keymap.set
--     local opts = { buffer = ev.buf, noremap = true, silent = true, desc = "LSP" }
--
--     map("n", "gd", vim.lsp.buf.definition, opts)
--     map("n", "K", vim.lsp.buf.hover, opts)
--     map("n", "gi", vim.lsp.buf.implementation, opts)
--     map("n", "gr", vim.lsp.buf.references, opts)
--     map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--     map("n", "<leader>rn", vim.lsp.buf.rename, opts)
--     map("n", "<leader>ld", vim.diagnostic.open_float, opts)
--   end,
-- })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
vim.cmd "autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()"
