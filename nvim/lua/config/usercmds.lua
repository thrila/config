vim.api.nvim_create_user_command("CommandBoard", function()
  require("telescope.builtin").commands()
end, { desc = "Open the interactive command board" })

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format the current buffer" })

vim.api.nvim_create_user_command("ProjectSymbols", function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Search workspace symbols" })

vim.api.nvim_create_user_command("NvimSpec", function()
  vim.cmd.edit(vim.fn.fnameescape(vim.fn.stdpath("config") .. "/SPEC.md"))
end, { desc = "Open the local Neovim spec sheet" })

vim.api.nvim_create_user_command("VenvProject", function()
  require("config.python").activate_project_venv(0, { notify = true, force = true })
end, { desc = "Activate the project .venv" })

vim.api.nvim_create_user_command("VenvCurrent", function()
  vim.notify(require("config.python").describe(), vim.log.levels.INFO)
end, { desc = "Show the active Python environment" })

vim.api.nvim_create_user_command("UvSync", function()
  if vim.fn.executable("uv") ~= 1 then
    vim.notify("uv is not installed or not on PATH", vim.log.levels.ERROR)
    return
  end

  local root = require("config.python").root(0) or vim.fn.getcwd()
  require("config.terminal").run({ "uv", "sync" }, { cwd = root })
end, { desc = "Run uv sync in the project root" })

vim.api.nvim_create_user_command("TermNew", function(opts)
  local term = require("config.terminal")
  if opts.args ~= "" then
    term.run(opts.args)
  else
    term.shell()
  end
end, {
  desc = "Open a new terminal buffer",
  nargs = "*",
})

vim.api.nvim_create_user_command("TermHere", function(opts)
  local term = require("config.terminal")
  if opts.args ~= "" then
    term.run(opts.args, { buf_only = true })
  else
    term.shell({ buf_only = true })
  end
end, {
  desc = "Open terminal in current buffer (no split)",
  nargs = "*",
})

vim.api.nvim_create_user_command("LazyGit", function()
  require("config.terminal").toggle_lazygit()
end, { desc = "Open LazyGit in a bottom split terminal" })

vim.api.nvim_create_user_command("OpenCode", function()
  if vim.fn.executable("opencode") ~= 1 then
    vim.notify("opencode not found on PATH", vim.log.levels.ERROR)
    return
  end
  require("config.terminal").open("opencode", { cwd = vim.fn.getcwd(), height = 20 })
end, { desc = "Open opencode in a terminal" })

vim.api.nvim_create_user_command("WebSearch", function(opts)
  local query = opts.args
  if query == "" then
    query = vim.fn.input("Search: ")
  end
  if query == "" then return end
  local url = "https://duckduckgo.com/?q=" .. vim.uri_encode(query)
  if vim.g.is_windows then
    vim.fn.jobstart({ "cmd", "/c", "start", url }, { detach = true })
  else
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  end
end, { nargs = "?", desc = "Search DuckDuckGo in default browser" })

vim.cmd([[
  cnoreabbrev <expr> term getcmdtype() ==# ':' && getcmdline() ==# 'term' ? 'TermNew' : 'term'
  cnoreabbrev <expr> terminal getcmdtype() ==# ':' && getcmdline() ==# 'terminal' ? 'TermNew' : 'terminal'
  cnoreabbrev <expr> termh getcmdtype() ==# ':' && getcmdline() ==# 'termh' ? 'TermHere' : 'termh'
]])
