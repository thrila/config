return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    version = "1.*",
    build = "cargo build --release",
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = "super-tab",
        -- ["<Tab>"] = {
        --   "snippet_forward",
        --   function() -- sidekick next edit suggestion
        --     return require("sidekick").nes_jump_or_apply()
        --   end,
        --   function() -- if you are using Neovim's native inline completions
        --     return vim.lsp.inline_completion.get()
        --   end,
        --   "fallback",
        -- },
      },

      appearance = {
        nerd_font_variant = "mono",
        -- menu = {
        --   border = "rounded",
        --   winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        -- },
      },

      completion = {
        keyword = { range = "prefix" },
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        accept = { auto_brackets = { enabled = true } },
        ghost_text = { enabled = true },
        menu = { draw = { treesitter = { "lsp" } } },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true, window = { border = "rounded" } },
      snippets = {
        preset = "luasnip",
      },
    },
    config = function(_, opts)
      local blink = require "blink.cmp"
      blink.setup(opts)

      -- Load VSCode-style snippet collections
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    opts_extend = { "sources.default", "sources.completion.enabled_providers", "sources.compat" },
  },
}
