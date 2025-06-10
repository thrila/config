-- set deno
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "denols"
end, lvim.lsp.automatic_configuration.skipped_servers)
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
local nvim_lsp = require("lspconfig")

local denoopts = {
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
}

local tsopts = {
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false
}

local lvim_manager = require("lvim.lsp.manager")
lvim_manager.setup("denols", denoopts)
lvim_manager.setup("tsserver", tsopts)
