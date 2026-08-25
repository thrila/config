-- vim.g.loaded_netrw = 0
-- vim.g.loaded_netrwPlugin = 0
-- vim.cmd("let g:netrw_liststyle = 3")
-- Disable netrw banner
vim.cmd "let g:netrw_banner = 0"

vim.g.deprecation_warnings = false -- Hide deprecation warnings

local opt = vim.opt

-- GUI
opt.background = "dark"
opt.scrolloff = 4 -- Lines of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.termguicolors = true -- True color support
opt.smoothscroll = true

-- Line numbers & decos
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.number = true -- Print line number

-- Code folding
opt.foldenable = true -- enable folds, but keep them open by default
opt.foldmethod = "expr" -- indent | manual | expr | marker | syntax
-- opt.foldtext = ""
-- Use the Treesitter folding expression
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Prevent folds from being closed by default when opening a file
vim.opt.foldlevel = 99 -- Set the default fold level (0 is all closed, high number is all open)
vim.opt.foldlevelstart = 99
-- Optional: Better visual indicators in the left gutter
vim.opt.foldcolumn = "1"
vim.opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}

-- Indentation
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count while performing edits
opt.smartindent = true -- Insert indents automatically
opt.wrap = false -- Disable line wrap
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.shiftround = true -- Round indent
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ "

-- Backup and undos
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000

-- Search settings
opt.inccommand = "split"
opt.hlsearch = true -- Highlight search text

-- Window splits
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.laststatus = 3
opt.splitright = true -- Put new windows right of current

-- Misc
opt.cursorline = true -- Enable highlighting of the current line
opt.completeopt = "menu,menuone,noselect"
opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.spelllang = { "en" }
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.isfname:append "@-@"
opt.updatetime = 100 -- Save swap file and trigger CursorHold
opt.colorcolumn = "100"
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Case-sensitive if uppercase in search
opt.timeoutlen = 400 -- Faster mapped sequence timeout
opt.shortmess:append "c" -- Less cmdline noise during completion

vim.g.editorconfig = true -- Coding styles across editors

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
opt.conceallevel = 2
vim.opt.winborder = "rounded"
