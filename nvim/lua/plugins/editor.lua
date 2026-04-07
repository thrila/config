return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps",
      },
    },
    opts = {
      delay = 200,
      preset = "modern",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>l", group = "lsp" },
        { "<leader>L", group = "local" },
        { "<leader>m", group = "markdown" },
        { "<leader>p", group = "plugins" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "tools" },
        { "<leader>v", group = "venv" },
      },
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = false,
    opts = {
      width = 110,
      minSideBufferWidth = 8,
      autocmds = {
        enableOnVimEnter = "safe",
        reloadOnColorSchemeChange = true,
      },
      mappings = {
        enabled = false,
      },
      integrations = {
        neotest = {
          position = "right",
          reopen = true,
        },
      },
      buffers = {
        wo = {
          cursorline = false,
          foldcolumn = "0",
          list = false,
          number = false,
          relativenumber = false,
          signcolumn = "no",
          wrap = false,
        },
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local logo = require("config.logo")

      require("dashboard").setup({
        theme = "hyper",
        config = {
          header = logo.header,
          shortcut = {
            { desc = " New file", key = "n", action = "ene | startinsert" },
            { desc = " Find file", key = "f", action = "Telescope find_files" },
            { desc = " Live grep", key = "g", action = "Telescope live_grep" },
            { desc = " Help tags", key = "h", action = "Telescope help_tags" },
          },
          project = { enable = false },
          mru = { enable = false },
          footer = logo.footer(),
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "gruvbox",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = {
          {
            function()
              return require("config.python").statusline()
            end,
            cond = function()
              return vim.bo.filetype == "python" and require("config.python").statusline() ~= ""
            end,
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        comments_only = true,
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 110,
      },
    },
  },
}
