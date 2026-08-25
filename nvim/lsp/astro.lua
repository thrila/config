---@brief
---
--- https://github.com/withastro/language-tools/tree/main/packages/language-server
---
--- `astro-ls` can be installed via `npm`:
--- ```sh
--- npm install -g @astrojs/language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
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