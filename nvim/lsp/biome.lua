---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```
---
--- ### Monorepo support
---
--- `biome` supports monorepos by default. It will automatically find the `biome.json` corresponding to the package you are working on, as described in the [documentation](https://biomejs.dev/guides/big-projects/#monorepo). This works without the need of spawning multiple instances of `biome`, saving memory.

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = "biome"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "astro",
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      -- If no file name, use cwd and enable biome as default
      on_dir(vim.fn.getcwd())
      return
    end

    -- Check if oxlint config exists - if so, don't enable biome (let oxlint handle)
    local has_oxlint = vim.fs.find({ ".oxlintrc.json", ".oxlintrc.js", ".oxlintrc.cjs" }, {
      path = fname,
      type = "file",
      limit = 1,
      upward = true,
    })[1]

    if has_oxlint then
      -- Oxlint project - biome will not attach
      return
    end

    -- Check for package.json with oxlint field
    local pkg_json = vim.fs.root(fname, { "package.json" })
    if pkg_json then
      local pkg_path = pkg_json .. "/package.json"
      if vim.fn.filereadable(pkg_path) == 1 then
        local content = vim.fn.readfile(pkg_path)
        local json_str = table.concat(content, "\n")
        if json_str:find('"oxlint"') then
          -- Oxlint in package.json - don't enable biome
          return
        end
      end
    end

    -- Not an oxlint project - enable biome as default
    -- Find project root
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })
    local project_root = vim.fs.root(fname, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
}
