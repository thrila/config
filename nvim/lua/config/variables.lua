local uv = vim.uv or vim.loop
local sysname = uv.os_uname().sysname

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.is_windows = sysname == "Windows_NT"
vim.g.is_linux = sysname == "Linux"
