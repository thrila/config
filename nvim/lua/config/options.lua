local opt = vim.opt

opt.background = "dark"
opt.termguicolors = true
opt.cursorline = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.wrap = false
opt.linebreak = false
opt.showmode = false
opt.cmdheight = 0
opt.laststatus = 3
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumblend = 10
opt.pumheight = 10
opt.winblend = 0
opt.conceallevel = 2
opt.concealcursor = "nc"

opt.clipboard:append("unnamedplus")

opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.confirm = true

opt.hidden = true
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.shortmess:append({ I = true, c = true, C = true })
opt.wildmode = "longest:full,full"
opt.winminwidth = 5

opt.fillchars = {
  foldopen = "v",
  foldclose = ">",
  fold = " ",
  foldsep = " ",
  eob = " ",
}

opt.list = true
opt.listchars = {
  tab = ">>",
  trail = ".",
  extends = ">",
  precedes = "<",
  nbsp = "+",
}

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99

if vim.g.is_windows then
  if vim.fn.executable("powershell") == 1 then
    opt.shell = "powershell"
    opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new(); $PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    opt.shellquote = ""
    opt.shellxquote = ""
    opt.shellpipe = "> %s 2>&1"
    opt.shellredir = "> %s 2>&1"
  else
    opt.shell = "cmd"
    opt.shellcmdflag = "/s /c"
    opt.shellquote = "\""
    opt.shellxquote = ""
    opt.shellpipe = "> %s 2>&1"
    opt.shellredir = "> %s 2>&1"
  end
elseif vim.g.is_linux and vim.fn.executable("fish") == 1 then
  opt.shell = "fish"
  opt.shellcmdflag = "-c"
end
