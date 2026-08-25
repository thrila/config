--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/linter.html
---
--- `oxlint` is a linter for JavaScript / TypeScript supporting over 500 rules from ESLint and its popular plugins.
--- It also supports linting framework files (Vue, Svelte, Astro) by analyzing their <script> blocks.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxlint
--- ```

---@type vim.lsp.Config
return {
  cmd = { "oxlint", "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
  },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "LspOxlintFixAll",
      function()
        client:exec_cmd {
          title = "Apply Oxlint automatic fixes",
          command = "oxc.fixAll",
          arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
        }
      end,
      {
        desc = "Apply Oxlint automatic fixes",
      }
    )
  end,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then return end

    -- Look for oxlint config files
    local root = vim.fs.root(fname, { ".oxlintrc.json", ".oxlintrc.js", ".oxlintrc.cjs" })

    -- If no explicit oxlintrc, check package.json for oxlint field
    if not root then
      local pkg_json = vim.fs.root(fname, { "package.json" })
      if pkg_json then
        local pkg_path = pkg_json .. "/package.json"
        if vim.fn.filereadable(pkg_path) == 1 then
          local content = vim.fn.readfile(pkg_path)
          local json_str = table.concat(content, "\n")
          -- Check for "oxlint" field in package.json
          if json_str:find('"oxlint"') then
            root = pkg_json
          end
        end
      end
    end

    -- Only enable if oxlint config is found
    if root then
      on_dir(root)
    end
  end,
  init_options = {
    settings = {
      -- ['run'] = 'onType',
      -- ['configPath'] = nil,
      -- ['tsConfigPath'] = nil,
      -- ['unusedDisableDirectives'] = 'allow',
      -- ['typeAware'] = false,
      -- ['disableNestedConfig'] = false,
      -- ['fixKind'] = 'safe_fix',
    },
  },
}
