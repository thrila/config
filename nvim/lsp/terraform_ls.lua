---@brief
---
--- https://github.com/hashicorp/terraform-ls
---
--- Terraform language server.

---@type vim.lsp.Config
return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "hcl" },
  root_markers = { ".terraform", ".git" },
}
