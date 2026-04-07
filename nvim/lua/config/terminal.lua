local M = {}

local lazygit_state = {
  bufnr = nil,
  winid = nil,
  origin_win = nil,
}

local function repo_root()
  local root = vim.fs.root(0, { ".git" })
  if root then
    return root
  end

  return vim.fn.getcwd()
end

local function terminal_shell()
  if vim.g.is_windows then
    if vim.fn.executable("powershell") == 1 then
      return "powershell -NoLogo -NoExit"
    end

    return "cmd /k"
  end

  if vim.g.is_linux and vim.fn.executable("fish") == 1 then
    return "fish"
  end

  return vim.o.shell
end

local function reset_lazygit_state()
  lazygit_state.bufnr = nil
  lazygit_state.winid = nil
  lazygit_state.origin_win = nil
end

local function is_valid_win(winid)
  return winid and vim.api.nvim_win_is_valid(winid)
end

local function first_survivor_win(excluded)
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if winid ~= excluded and vim.api.nvim_win_is_valid(winid) then
      return winid
    end
  end
end

local function setup_terminal_window()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.scrolloff = 0
  vim.bo.buflisted = false
end

local function open_bottom_terminal(cmd, opts)
  opts = opts or {}

  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, opts.height or 15)
  vim.wo.winfixheight = true

  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  setup_terminal_window()

  local job_opts = vim.empty_dict()
  if opts.cwd then
    job_opts.cwd = opts.cwd
  end
  if opts.on_exit then
    job_opts.on_exit = opts.on_exit
  end

  vim.fn.termopen(cmd, job_opts)

  vim.cmd.startinsert()

  return {
    bufnr = bufnr,
    winid = winid,
  }
end

local function finish_lazygit()
  local lazygit_win = lazygit_state.winid
  local origin_win = lazygit_state.origin_win
  local target_win = nil

  if is_valid_win(origin_win) then
    target_win = origin_win
  else
    target_win = first_survivor_win(lazygit_win)
  end

  if target_win then
    vim.api.nvim_set_current_win(target_win)
  end

  if is_valid_win(lazygit_win) then
    if #vim.api.nvim_list_wins() > 1 then
      vim.api.nvim_win_close(lazygit_win, true)
    else
      vim.api.nvim_set_current_win(lazygit_win)
      vim.cmd.enew()
    end
  elseif #vim.api.nvim_list_wins() == 0 then
    vim.cmd.enew()
  end

  reset_lazygit_state()

  vim.schedule(function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
      gitsigns.refresh()
    end
  end)
end

function M.toggle_lazygit()
  if vim.fn.executable("lazygit") ~= 1 then
    vim.notify("lazygit is not installed or not on PATH", vim.log.levels.ERROR)
    return
  end

  if is_valid_win(lazygit_state.winid) then
    vim.api.nvim_set_current_win(lazygit_state.winid)
    vim.cmd.startinsert()
    return
  end

  lazygit_state.origin_win = vim.api.nvim_get_current_win()
  local term = open_bottom_terminal("lazygit", {
    cwd = repo_root(),
    height = 18,
    on_exit = function()
      vim.schedule(finish_lazygit)
    end,
  })

  lazygit_state.winid = term.winid
  lazygit_state.bufnr = term.bufnr
end

function M.open_shell(opts)
  opts = opts or {}
  return open_bottom_terminal(terminal_shell(), {
    cwd = opts.cwd,
    height = opts.height or 15,
  })
end

function M.open_command(command, opts)
  opts = opts or {}
  return open_bottom_terminal(command, {
    cwd = opts.cwd,
    height = opts.height or 15,
  })
end

return M
