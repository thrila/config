local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General clear highlights" })

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Window
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Splitting window
-- To open a new vertical split
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split Vertically" })
-- To open a new horizontal split
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split Horizontally" })
-- Close current window
map("n", "<leader>wq", "<cmd>close<cr>", { desc = "Close Window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Buffers

-- Tabs
-- map("n", "<leader>tn", "<cmd>tabnew<CR>", {desc = "Create a new tab"})
-- map("n", "<leader>tn", "<cmd>tabnew %<CR>", {desc = "Create a new tab from current file"})
-- map("n", "<leader>tc", "<cmd>tabc<CR>", {desc = "Close the current tab and all its windows"})
-- map("n", "<leader>tdo", "<cmd>tabo<CR>", {desc = "Close all tabs except for the current one"})
-- map("n", "<leader>tn", "<cmd>tabn<CR>", {desc = "Move to the next tab"})
-- map("n", "<leader>tp", "<cmd>tabp<CR>", {desc = "Move to the previous tab"})

-- Clipboard
map("x", "<leader>pp", [["_dp]]) -- Paste without replacing clipboard content
map({ "n", "v" }, "<leader>dd", [["_d]]) -- Deletes without adding to clipboard
map("n", "x", '"_x', opts) -- prevent x delete from registering when next paste

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- Saving file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Code
map("n", "<leader>br", function() require("config.build").run() end, { desc = "Run project" })
map("n", "<leader>bb", function() require("config.build").build() end, { desc = "Build project" })
map("n", "<leader>bt", function() require("config.build").test() end, { desc = "Test project" })

-- LSP

-- Misc
-- Replace the word cursor is on globally
map(
  "n",
  "<leader>sr",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)
