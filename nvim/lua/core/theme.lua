local M = {}

M.themes = {
  "catppuccin",
  "gruvbox",
  "kanagawa",
  "vesper",
  "rose-pine",
  "monokai-pro",
  "cyberdream",
  "oxocarbon",
  "tokyonight",
  "flexoki",
}

M.default_theme = "monokai-pro"
M.variant_options = {
  catppuccin = { "latte", "frappe", "macchiato", "mocha" },
  kanagawa = { "wave", "dragon", "lotus" },
  ["rose-pine"] = { "main", "moon", "dawn" },
  ["monokai-pro"] = { "pro", "classic", "octagon", "machine", "ristretto", "spectrum", "light" },
  cyberdream = { "default", "light", "dark" },
  oxocarbon = { "dark", "light" },
  tokyonight = { "storm", "night", "moon", "day" },
  flexoki = { "dark", "light" },
}
M.default_variants = {
  catppuccin = "mocha",
  kanagawa = "wave",
  ["rose-pine"] = "main",
  ["monokai-pro"] = "pro",
  cyberdream = "default",
  oxocarbon = "dark",
  tokyonight = "night",
  flexoki = "dark",
}
M.state_file = vim.fn.stdpath "state" .. "/theme.json"

---@param theme string
---@return boolean
local function is_valid_theme(theme) return vim.tbl_contains(M.themes, theme) end

---@param theme string
---@param variant string|nil
---@return boolean
local function is_valid_variant(theme, variant)
  if variant == nil then return true end
  local options = M.variant_options[theme]
  if not options then return false end
  return vim.tbl_contains(options, variant)
end

---@param state table
local function persist(state)
  local dir = vim.fn.fnamemodify(M.state_file, ":h")
  vim.fn.mkdir(dir, "p")
  local payload = vim.json.encode(state)
  vim.fn.writefile({ payload }, M.state_file)
end

---@return {theme: string, variants: table<string, string>}
function M.get_state()
  local state = {
    theme = M.default_theme,
    variants = {},
  }

  if vim.fn.filereadable(M.state_file) ~= 1 then return state end
  local lines = vim.fn.readfile(M.state_file)
  if not lines or #lines == 0 then return state end

  local ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(decoded) ~= "table" then return state end

  local theme = decoded.theme
  if type(theme) == "string" and is_valid_theme(theme) then state.theme = theme end

  if type(decoded.variants) == "table" then
    for name, variant in pairs(decoded.variants) do
      if type(name) == "string" and type(variant) == "string" and is_valid_variant(name, variant) then
        state.variants[name] = variant
      end
    end
  elseif type(decoded.variant) == "string" and is_valid_variant(state.theme, decoded.variant) then
    -- Backward compatibility with old payload shape { theme = "...", variant = "..." }
    state.variants[state.theme] = decoded.variant
  end

  return state
end

---@return string
function M.get_saved_theme()
  local state = M.get_state()
  return state.theme
end

---@param theme string
---@return string|nil
function M.get_saved_variant(theme)
  local state = M.get_state()
  local variant = state.variants[theme]
  if variant and is_valid_variant(theme, variant) then return variant end
  return M.default_variants[theme]
end

---@param theme string
---@param variant string|nil
local function resolve_colorscheme(theme, variant)
  if theme == "catppuccin" and variant then
    return "catppuccin-" .. variant
  elseif theme == "kanagawa" and variant then
    return "kanagawa-" .. variant
  elseif theme == "rose-pine" and variant and variant ~= "main" then
    return "rose-pine-" .. variant
  elseif theme == "monokai-pro" and variant and variant ~= "pro" then
    return "monokai-pro-" .. variant
  elseif theme == "oxocarbon" then
    return "oxocarbon"
  elseif theme == "tokyonight" and variant then
    return "tokyonight-" .. variant
  elseif theme == "flexoki" and variant then
    return "flexoki-" .. variant
  else
    return theme
  end
end

---@param theme string
---@param opts? { persist: boolean, variant: string|nil }
---@return boolean
function M.apply(theme, opts)
  opts = opts or {}
  if opts.persist == nil then opts.persist = true end

  if not is_valid_theme(theme) then
    vim.notify(("Theme '%s' is not in configured theme list"):format(theme), vim.log.levels.WARN)
    return false
  end

  local variant = opts.variant
  if variant == nil then
    variant = M.get_saved_variant(theme)
  elseif not is_valid_variant(theme, variant) then
    vim.notify(("Variant '%s' is not valid for theme '%s'"):format(variant, theme), vim.log.levels.WARN)
    return false
  end

  local resolved = resolve_colorscheme(theme, variant)
  if theme == "oxocarbon" and variant then
    vim.o.background = variant
  end
  local ok, err = pcall(vim.cmd.colorscheme, resolved)
  if not ok then
    vim.notify(("Failed to apply theme '%s': %s"):format(resolved, tostring(err)), vim.log.levels.ERROR)
    return false
  end

  if opts.persist then
    local state = M.get_state()
    state.theme = theme
    if variant and is_valid_variant(theme, variant) then state.variants[theme] = variant end
    local persist_ok, persist_err = pcall(persist, state)
    if not persist_ok then
      vim.notify(("Theme applied but failed to persist: %s"):format(tostring(persist_err)), vim.log.levels.WARN)
    end
  end

  return true
end

function M.load_persisted_or_default()
  local theme = M.get_saved_theme()
  if not M.apply(theme, { persist = false }) then
    M.apply(M.default_theme, { persist = false, variant = M.default_variants[M.default_theme] })
  end
end

function M.pick()
  vim.ui.select(M.themes, {
    prompt = "Choose colorscheme",
    format_item = function(item) return item end,
  }, function(choice)
    if not choice then return end
    M.apply(choice, { persist = true })
  end)
end

function M.pick_variant()
  local theme = M.get_saved_theme()
  local variants = M.variant_options[theme]
  if not variants then
    vim.notify(("Theme '%s' has no configurable variants"):format(theme), vim.log.levels.INFO)
    return
  end

  vim.ui.select(variants, {
    prompt = ("Choose %s variant"):format(theme),
    format_item = function(item) return item end,
  }, function(choice)
    if not choice then return end
    M.apply(theme, { persist = true, variant = choice })
  end)
end

function M.setup()
  M.load_persisted_or_default()

  vim.api.nvim_create_user_command("Theme", function() M.pick() end, {
    desc = "Select and apply colorscheme",
  })
  vim.api.nvim_create_user_command("ThemeVariant", function() M.pick_variant() end, {
    desc = "Select and apply theme variant",
  })
  vim.keymap.set("n", "<leader>uC", function() M.pick() end, { desc = "Select Colorscheme" })
  vim.keymap.set("n", "<leader>uV", function() M.pick_variant() end, { desc = "Select Theme Variant" })
end

return M
