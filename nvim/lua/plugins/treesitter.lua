return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "astro",
          "bash",
          "caddy",
          "cmake",
          "css",
          "csv",
          "html",
          "javascript",
          "typescript",
          "tsx",
          "rust",
          "go",
          "scss",
          "python",
          "sql",
          "terraform",
          "prisma",
          "dockerfile",
          "gitignore",
          "gitcommit",
          "regex",
          "yaml",
          "jsdoc",
          "json",
          "jsonc",
          "xml",
          "toml",
        },
        auto_install = true,
        sync_install = false,
        modules = {},
        highlight = { enable = true }, -- Enable highlighting
        indent = { enable = true }, -- Enable indentation
        ignore_install = {},
        fold = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        additional_vim_regex_highlighting = false,
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      }
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
