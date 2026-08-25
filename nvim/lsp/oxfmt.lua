--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/formatter.html
---
--- `oxfmt` is a Prettier-compatible code formatter that supports multiple languages
--- including JavaScript, TypeScript, JSON, YAML, HTML, CSS, Markdown, and more.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxfmt
--- ```

---@type vim.lsp.Config
return {
  cmd = { "oxfmt", "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "toml",
    "json",
    "jsonc",
    "json5",
    "yaml",
    "html",
    "vue",
    "handlebars",
    "hbs",
    "css",
    "scss",
    "less",
    "graphql",
    "markdown",
    "mdx",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then return end

    -- Look for oxfmt config files (.oxfmtrc.json ONLY, no package.json fallback)
    local root_markers = { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }
    local root = vim.fs.root(fname, root_markers)

    -- Only enable if oxfmt config is explicitly found
    if root then
      on_dir(root)
    end
  end,
}
