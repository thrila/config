local function has_config_file(bufnr, filenames)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return false end
  for _, filename in ipairs(filenames) do
    local filepath = vim.fs.dirname(path) .. "/" .. filename
    if vim.fn.filereadable(filepath) == 1 then return true end
  end
  return false
end

local function get_js_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.yaml",
      ".prettierrc.yml",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_json_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_yaml_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif has_config_file(bufnr, {
    ".prettierrc",
    ".prettierrc.yaml",
    ".prettierrc.yml",
  }) then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_html_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.html",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_css_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.css",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_markdown_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.md",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_handlebars_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  elseif
    has_config_file(bufnr, {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.js",
      ".prettierrc.cjs",
      ".prettierrc.handlebars",
      "prettier.config.js",
    })
  then
    return { "prettier" }
  else
    return { "biome" }
  end
end

local function get_toml_formatter(bufnr)
  if has_config_file(bufnr, { ".oxfmtrc.json", ".oxfmtrc.js", ".oxfmtrc.cjs" }) then
    return { "oxfmt" }
  else
    return { "biome" }
  end
end

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    -- "zapling/mason-conform.nvim",
  },
  config = function()
    -- require("mason-conform").setup()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        zsh = { "shfmt" },
        sh = { "shfmt" },
        javascript = get_js_formatter,
        typescript = get_js_formatter,
        astro = get_js_formatter,
        javascriptreact = get_js_formatter,
        typescriptreact = get_js_formatter,
        rust = { "rustfmt", lsp_format = "fallback" },
        prisma = { "biome" },
        terraform = { "terraform" },
        jsonc = get_json_formatter,
        json = get_json_formatter,
        yaml = get_yaml_formatter,
        html = get_html_formatter,
        css = get_css_formatter,
        scss = get_css_formatter,
        less = get_css_formatter,
        markdown = get_markdown_formatter,
        ["markdown.mdx"] = get_markdown_formatter,
        handlebars = get_handlebars_formatter,
        hbs = get_handlebars_formatter,
        toml = get_toml_formatter,
        go = { "gofumpt", "golines" },
        python = { "isort", "black", stop_after_first = true },
        graphql = { "biome" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    }
  end,
}
