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
  require("config.terminal").open_command({ "uv", "sync" }, { cwd = root })
end, { desc = "Run uv sync in the project root" })

vim.api.nvim_create_user_command("TermNew", function(opts)
  if opts.args ~= "" then
    require("config.terminal").open_command(opts.args)
  else
    require("config.terminal").open_shell()
  end
end, {
  desc = "Open a new terminal buffer",
  nargs = "*",
})

vim.api.nvim_create_user_command("LazyGit", function()
  require("config.terminal").toggle_lazygit()
end, { desc = "Open LazyGit in a bottom split terminal" })

vim.cmd([[
  cnoreabbrev <expr> term getcmdtype() ==# ':' && getcmdline() ==# 'term' ? 'TermNew' : 'term'
  cnoreabbrev <expr> terminal getcmdtype() ==# ':' && getcmdline() ==# 'terminal' ? 'TermNew' : 'terminal'
]])
