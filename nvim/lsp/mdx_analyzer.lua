---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

---@type vim.lsp.Config
return {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx", "markdown" },
  root_markers = { "package.json", "tsconfig.json", ".git" },
  settings = {},
  before_init = function(_, config)
    local root_dir = config.root_dir
    local tsdk_paths = {
      vim.fn.expand("~/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"),
      root_dir and (root_dir .. "/node_modules/typescript/lib"),
      root_dir and (root_dir .. "/../node_modules/typescript/lib"),
    }
    for _, path in ipairs(tsdk_paths) do
      if path and vim.fn.isdirectory(path) == 1 then
        config.init_options = config.init_options or {}
        config.init_options.typescript = { tsdk = path }
        break
      end
    end
  end,
}