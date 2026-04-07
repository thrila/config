local M = {}

local root_markers = {
  "pyproject.toml",
  "uv.lock",
  ".venv",
  ".python-version",
  "requirements.txt",
  "setup.py",
  "setup.cfg",
  "Pipfile",
  "pyrightconfig.json",
  ".git",
}

local function is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

local function normalize(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function selector()
  local ok, venv_selector = pcall(require, "venv-selector")
  if ok then
    return venv_selector
  end
end

local function python_from_venv(venv)
  if not venv or venv == "" then
    return nil
  end

  local python = is_windows() and (venv .. "/Scripts/python.exe") or (venv .. "/bin/python")
  python = normalize(python)

  if python and vim.fn.executable(python) == 1 then
    return python
  end
end

local function path_starts_with(path, prefix)
  path = normalize(path)
  prefix = normalize(prefix)

  return path ~= nil and prefix ~= nil and vim.startswith(path, prefix)
end

function M.root(bufnr)
  return vim.fs.root(bufnr or 0, root_markers)
end

function M.project_python(root)
  root = normalize(root or M.root(0))
  if not root then
    return nil
  end

  return python_from_venv(root .. "/.venv")
end

function M.project_venv(root)
  local python = M.project_python(root)
  if not python then
    return nil
  end

  return normalize(vim.fs.dirname(vim.fs.dirname(python)))
end

function M.current_venv()
  local venv_selector = selector()
  if venv_selector then
    return normalize(venv_selector.venv())
  end

  return normalize(vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX)
end

function M.current_python()
  local venv_selector = selector()
  if venv_selector then
    return normalize(venv_selector.python())
  end

  return python_from_venv(vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX)
end

local function should_keep_current_selection(root, desired_venv)
  local current_venv = M.current_venv()
  if not current_venv then
    return false
  end

  if current_venv == normalize(desired_venv) then
    return true
  end

  return path_starts_with(current_venv, root)
end

function M.activate_project_venv(bufnr, opts)
  opts = opts or {}
  bufnr = bufnr or 0

  local root = normalize(M.root(bufnr))
  if not root then
    if opts.notify then
      vim.notify("No Python project root found for this buffer.", vim.log.levels.WARN)
    end
    return false
  end

  local python = M.project_python(root)
  if not python then
    if opts.notify then
      vim.notify("No project .venv found under " .. root, vim.log.levels.WARN)
    end
    return false
  end

  local desired_venv = M.project_venv(root)
  if not opts.force and should_keep_current_selection(root, desired_venv) then
    return true
  end

  local venv_selector = selector()
  if not venv_selector then
    if opts.notify then
      vim.notify("venv-selector is not available yet. Run :Lazy sync once.", vim.log.levels.ERROR)
    end
    return false
  end

  if normalize(venv_selector.python()) == python then
    return true
  end

  local ok, err = pcall(venv_selector.activate_from_path, python)
  if not ok then
    if opts.notify then
      vim.notify("Failed to activate project .venv: " .. err, vim.log.levels.ERROR)
    end
    return false
  end

  if opts.notify then
    vim.notify("Activated " .. M.label(), vim.log.levels.INFO)
  end

  return true
end

function M.label()
  local venv = M.current_venv()
  if not venv then
    return ""
  end

  local name = vim.fn.fnamemodify(venv, ":t")
  if name == ".venv" then
    local project = vim.fn.fnamemodify(vim.fs.dirname(venv), ":t")
    return "uv:" .. project
  end

  return "uv:" .. name
end

function M.statusline()
  return M.label()
end

function M.describe()
  local lines = {}
  local venv = M.current_venv()
  local python = M.current_python()

  if not venv and not python then
    return "No active Python environment."
  end

  if venv then
    table.insert(lines, "venv: " .. venv)
  end

  if python then
    table.insert(lines, "python: " .. python)
  end

  return table.concat(lines, "\n")
end

function M.setup()
  if M._did_setup then
    return
  end

  M._did_setup = true

  local group = vim.api.nvim_create_augroup("UvProjectVenv", { clear = true })

  local function auto_activate(args)
    local bufnr = args.buf or vim.api.nvim_get_current_buf()

    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype ~= "python" then
      return
    end

    vim.schedule(function()
      M.activate_project_venv(bufnr, { notify = false })
    end)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = auto_activate,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = auto_activate,
  })

  auto_activate({ buf = vim.api.nvim_get_current_buf() })
end

return M
