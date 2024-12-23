-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny



vim.opt.relativenumber = true      -- relative line numbers
lvim.format_on_save.enabled = true -- format on save
-- lvim.transparent_window = true                  -- make window transparent
lvim.colorscheme = "tokyonight"
lvim.builtin.nvimtree.setup.view.side = "right" -- file nav to the right



lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- require('nvim-treesitter.configs').setup {}
-- nvim-ts-context-commentstring is set up automatically
lvim.plugins = {
  {
    "wakatime/vim-wakatime"
  },
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
}


local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    args = { "--print-width", "100" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
}
-- set deno
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "denols"
end, lvim.lsp.automatic_configuration.skipped_servers)
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
local nvim_lsp = require("lspconfig")

local denoopts = {
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
}

local tsopts = {
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false
}

local lvim_manager = require("lvim.lsp.manager")
lvim_manager.setup("denols", denoopts)
lvim_manager.setup("tsserver", tsopts)

-- logo
lvim.builtin.alpha.dashboard.section.header.val = {
  " ",
  " ",
  " █████╗ ██████╗  ██████╗ █████╗ ██████╗ ███████╗ ██████╗ ██╗    ██╗██╗██████╗ ███████╗██████╗ ",
  "██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔═══██╗██║    ██║██║██╔══██╗██╔════╝██╔══██╗",
  "███████║██████╔╝██║     ███████║██║  ██║█████╗  ██║██╗██║██║ █╗ ██║██║██████╔╝█████╗  ██║  ██║",
  "██╔══██║██╔══██╗██║     ██╔══██║██║  ██║██╔══╝  ██║██║██║██║███╗██║██║██╔══██╗██╔══╝  ██║  ██║",
  "██║  ██║██║  ██║╚██████╗██║  ██║██████╔╝███████╗╚█║████╔╝╚███╔███╔╝██║██║  ██║███████╗██████╔╝",
  "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚══════╝ ╚╝╚═══╝  ╚══╝╚══╝ ╚═╝╚═╝  ╚═╝╚══════╝╚═════╝ ",
  " ",
}
