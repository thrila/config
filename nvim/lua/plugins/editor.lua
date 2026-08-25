return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
        -- stylua: ignore
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)", },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)", },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)", },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)", },
        },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
        -- stylua: ignore
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon:setup(opts)

            -- basic mappings
            local map = vim.keymap.set
            map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon Add File" })
            map("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })
            -- direct navigation (slots 1-4)
            map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
            map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
            map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
            map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })
        end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        -- { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },

  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Smear cursor when switching buffers or windows.
      smear_between_buffers = true,

      -- Smear cursor when moving within line or to neighbor lines.
      min_horizontal_distance_smear = 25,
      min_vertical_distance_smear = 25,

      -- Draw the smear in buffer space instead of screen space when scrolling
      scroll_buffer_space = true,

      -- Smear cursor in insert mode.
      smear_insert_mode = false,

      -- How fast the smear's head moves towards the target.
      stiffness = 0.6,

      -- How fast the smear's tail moves towards the target.
      trailing_stiffness = 0.45,
    },
  },

  {
    "hrsh7th/vim-vsnip",
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    opts = {
      default_mappings = true, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = "copen", -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },

  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
}
