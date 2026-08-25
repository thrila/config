local ok, blink = pcall(require, "blink.cmp")
local blink_capabilities = vim.lsp.protocol.make_client_capabilities()

if ok then blink_capabilities = blink.get_lsp_capabilities(blink_capabilities) end
vim.lsp.config("*", { capabilities = blink_capabilities })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local map = vim.keymap.set
    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client:supports_method "textDocument/completion" then
    --   vim.opt.completeopt = { "menu", "menuone", "fuzzy", "popup" }
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    --   vim.keymap.set("i", "<C-Space>", function() vim.lsp.completion.get() end)
    -- end

    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map(
      "n",
      "<leader>fm",
      function() vim.lsp.buf.format { async = true } end,
      vim.tbl_extend("force", opts, { desc = "Format" })
    )
    -- map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    map("n", "<leader>se", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
  end,
})

-- Copilot Attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig-Copilot", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "copilot" then return end

    -- Check for native inline completion support in this version of Neovim
    if client.supports_method "textDocument/inlineCompletion" and vim.lsp.inline_completion then
      local bufnr = args.buf
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      -- Keymaps for accepting/switching suggestions
      vim.keymap.set(
        "i",
        "<C-F>",
        function() vim.lsp.inline_completion.accept() end,
        { desc = "LSP: Accept Inline Completion", buffer = bufnr }
      )
      vim.keymap.set(
        "i",
        "<C-G>",
        function() vim.lsp.inline_completion.next() end,
        { desc = "LSP: Next Inline Completion", buffer = bufnr }
      )
    end
  end,
})

vim.diagnostic.config {
  virtual_lines = false,
  -- virtual_lines = { current_line = false },
  virtual_text = { prefix = "●" },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "⚠",
      [vim.diagnostic.severity.INFO] = "ℹ",
      [vim.diagnostic.severity.HINT] = "💡",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
}

-- rustaceanvim starts rust_analyzer, so it has been removed from this list
local servers = {
  "lua_ls",
  "html",
  "vtsls",
  -- "ts_ls", -- disabled in favour of vstsls
  "biome",
  "stylua",
  "tailwindcss",
  "docker_language_server",
  "docker_compose_language_service",
  "cspell_ls",
  "terraform_ls",
  "vscode-css-language-server",
  "css-variables-language-server",
  "cssmodules_ls",
  "prismals",
  "gopls",
  "golangci_lint_ls",
  "laravel_ls",
  "stylelint_lsp",
  "jsonls",
  "gh_actions_ls",
  "typos_lsp",
  "yamlls",
  -- "copilot",
  "markdown_oxide",
  "astro",
  "oxlint",
  "oxfmt",
}

for _, server_name in ipairs(servers) do
  vim.lsp.enable(server_name)
end
