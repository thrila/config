local map = vim.keymap.set

local function load_neotest()
  require("lazy").load({
    plugins = {
      "nvim-nio",
      "neotest",
      "neotest-jest",
      "neotest-python",
      "neotest-rust",
    },
  })

  return require("neotest")
end

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "K", function()
  require("config.lsp").hover()
end, { desc = "Hover / keyword help" })
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>;", "<cmd>Dashboard<cr>", { desc = "Dashboard" })
map("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "File explorer" })
map("n", "<leader>Lc", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit config" })
map("n", "<leader>Ls", "<cmd>NvimSpec<cr>", { desc = "Open spec sheet" })
map("n", "<leader>pS", "<cmd>Lazy<cr>", { desc = "Installed plugins" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Search help" })
map("n", "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Search keymaps" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo comments" })
map("n", "<leader>fc", "<cmd>CommandBoard<cr>", { desc = "Command board" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Commands" })

map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })

map("n", "<leader>ha", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

for index = 1, 4 do
  map("n", "<leader>" .. index, function()
    require("harpoon"):list():select(index)
  end, { desc = "Harpoon file " .. index })
end

map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>th", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tl", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tt", "<cmd>TermNew<cr>", { desc = "New terminal" })
map("n", "<leader>tn", "<cmd>NoNeckPain<cr>", { desc = "Toggle centered layout" })
map("n", "<leader>vc", "<cmd>VenvSelectCached<cr>", { desc = "Cached Python env" })
map("n", "<leader>vi", "<cmd>VenvCurrent<cr>", { desc = "Active Python env" })
map("n", "<leader>vp", "<cmd>VenvProject<cr>", { desc = "Project .venv" })
map("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python env" })
map("n", "<leader>vu", "<cmd>UvSync<cr>", { desc = "uv sync" })
map("n", "<leader>zz", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })

map("n", "<leader>tm", function()
  load_neotest().run.run()
end, { desc = "Test nearest" })

map("n", "<leader>tf", function()
  load_neotest().run.run(vim.fn.expand("%"))
end, { desc = "Test file" })

map("n", "<leader>ts", function()
  load_neotest().summary.toggle()
end, { desc = "Test summary" })

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview" })
map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP info" })
map("n", "<leader>lR", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })

map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<S-h>", [[<C-\><C-n><Cmd>bprevious<CR>]], { desc = "Previous buffer" })
map("t", "<S-l>", [[<C-\><C-n><Cmd>bnext<CR>]], { desc = "Next buffer" })
map("t", "gT", [[<C-\><C-n>gT]], { desc = "Previous tab" })
map("t", "gt", [[<C-\><C-n>gt]], { desc = "Next tab" })
map("t", "<leader>bd", [[<C-\><C-n><Cmd>bdelete<CR>]], { desc = "Delete buffer" })
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Go to left window" })
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Go to lower window" })
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Go to upper window" })
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Go to right window" })
map("t", "<leader>th", [[<C-\><C-n><Cmd>tabprevious<CR>]], { desc = "Previous tab" })
map("t", "<leader>tl", [[<C-\><C-n><Cmd>tabnext<CR>]], { desc = "Next tab" })
map("t", "<leader>to", [[<C-\><C-n><Cmd>tabnew<CR>]], { desc = "New tab" })
map("t", "<leader>tx", [[<C-\><C-n><Cmd>tabclose<CR>]], { desc = "Close tab" })
