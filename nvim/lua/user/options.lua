vim.opt.relativenumber = true                   -- relative line numbers
lvim.format_on_save.enabled = true              -- format on save
lvim.colorscheme = "monokai-pro"
lvim.builtin.nvimtree.setup.view.side = "right" -- file nav to the right
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
--
-- lvim.transparent_window = true -- make window transparent
-- require('nvim-treesitter.configs').setup {}
-- nvim-ts-context-commentstring is set up automatically
