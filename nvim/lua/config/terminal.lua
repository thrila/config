local M = {}

-- ── State ──────────────────────────────────────────────────────────────────

local lazygit = {
  bufnr = nil,
  winid = nil,
  origin_win = nil,
}

-- ── Helpers ────────────────────────────────────────────────────────────────

local function repo_root()
  return vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
end

local function shell_cmd()
  if vim.g.is_windows then
    if vim.fn.executable("nu") == 1 then
      return "nu"
    end
    return vim.fn.executable("powershell") == 1
      and "powershell -NoLogo -NoExit"
      or "cmd /k"
  end
  if vim.g.is_linux and vim.fn.executable("fish") == 1 then
    return "fish"
  end
  return vim.o.shell
end

local function win_valid(winid)
  return winid and vim.api.nvim_win_is_valid(winid)
end

local function pick_win(exclude)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if w ~= exclude and vim.api.nvim_win_is_valid(w) then
      return w
    end
  end
end

local function strip_numbering()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.scrolloff = 0
end

-- ── Core launcher ──────────────────────────────────────────────────────────

---Open a terminal.
---@param cmd string|string[]  shell or command
---@param opts? {split:boolean?, height:number?, cwd:string?, on_exit:fun()?, buf_only:boolean?, delay_close:boolean?}
function M.open(cmd, opts)
  opts = opts or {}

  local bufnr, winid

  if opts.buf_only then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, bufnr)
    winid = vim.api.nvim_get_current_win()
  else
    vim.cmd.new()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, opts.height or 15)
    vim.wo.winfixheight = true
    winid = vim.api.nvim_get_current_win()
    bufnr = vim.api.nvim_get_current_buf()
  end

  strip_numbering()
  vim.bo[bufnr].buflisted = false

  if opts.delay_close then
    vim.b[bufnr].term_delay_close = true
  end

  local job_opts = vim.empty_dict()
  if opts.cwd then job_opts.cwd = opts.cwd end

  if opts.on_exit then
    vim.b[bufnr].term_managed = true
    job_opts.on_exit = function(_, exitcode, _)
      vim.schedule(function()
        opts.on_exit(exitcode)
      end)
    end
  end

  vim.fn.termopen(cmd, job_opts)
  vim.cmd.startinsert()

  return { bufnr = bufnr, winid = winid }
end

-- ── LazyGit ────────────────────────────────────────────────────────────────

local function cleanup_lazygit()
  local target = win_valid(lazygit.origin_win)
    and lazygit.origin_win
    or  pick_win(lazygit.winid)

  if target then
    vim.api.nvim_set_current_win(target)
  end

  if win_valid(lazygit.winid) then
    if #vim.api.nvim_list_wins() > 1 then
      vim.api.nvim_win_close(lazygit.winid, true)
    else
      vim.cmd.enew()
    end
  elseif #vim.api.nvim_list_wins() == 0 then
    vim.cmd.enew()
  end

  lazygit.bufnr = nil
  lazygit.winid = nil
  lazygit.origin_win = nil

  vim.schedule(function()
    pcall(require("gitsigns").refresh)
  end)
end

function M.toggle_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit not found on PATH", vim.log.levels.ERROR)
    return
  end

  if win_valid(lazygit.winid) then
    vim.api.nvim_set_current_win(lazygit.winid)
    vim.cmd.startinsert()
    return
  end

  lazygit.origin_win = vim.api.nvim_get_current_win()
  local t = M.open("lazygit", {
    cwd = repo_root(),
    height = 18,
    on_exit = cleanup_lazygit,
  })
  lazygit.bufnr = t.bufnr
  lazygit.winid = t.winid
end

-- ── Public commands ────────────────────────────────────────────────────────

function M.shell(opts)
  return M.open(shell_cmd(), {
    cwd   = opts and opts.cwd,
    height = opts and opts.height or 15,
  })
end

function M.run(command, opts)
  return M.open(command, {
    cwd    = opts and opts.cwd,
    height = opts and opts.height or 15,
  })
end

return M
