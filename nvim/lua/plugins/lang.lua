return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = {
      "VenvSelect",
      "VenvSelectCached",
      "VenvSelectLog",
    },
    ft = "python",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return {
        options = {
          picker = "telescope",
          enable_cached_venvs = true,
          cached_venv_automatic_activation = false,
          activate_venv_in_terminal = true,
          set_environment_variables = true,
          require_lsp_activation = false,
          notify_user_on_venv_activation = false,
          search_timeout = 3,
          statusline_func = {
            lualine = function()
              return require("config.python").statusline()
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      require("venv-selector").setup(opts)
      require("config.python").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },
      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = true },
    },
    config = function(_, opts)
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup(opts)
        return
      end

      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      if opts.ensure_installed and #opts.ensure_installed > 0 then
        pcall(treesitter.install, opts.ensure_installed)
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "denols",
        "intelephense",
        "lua_ls",
        "marksman",
        "pyright",
        "ts_ls",
        "tinymist",
      },
      automatic_enable = false,
    },
    config = function(_, opts)
      local lsp = require("config.lsp")
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup(opts)

      local function resolve_rust_analyzer()
        local cargo_home = vim.env.CARGO_HOME or (vim.fn.expand("~") .. "/.cargo")
        local cargo_bin = cargo_home .. (vim.fn.has("win32") == 1 and "/bin/rust-analyzer.exe" or "/bin/rust-analyzer")

        if vim.fn.filereadable(cargo_bin) == 1 then
          return cargo_bin
        end

        return "rust-analyzer"
      end

      local function root(bufnr, markers)
        return vim.fs.root(bufnr, markers)
      end

      local function rust_root_dir(bufnr, on_dir)
        local dir = root(bufnr, { "Cargo.toml", "rust-project.json", ".git" })
        if dir then
          on_dir(dir)
          return
        end

        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename ~= "" then
          on_dir(vim.fs.dirname(filename))
          return
        end

        on_dir(vim.fn.getcwd())
      end

      local servers = {
        clangd = {},
        denols = {
          root_dir = function(bufnr, on_dir)
            local dir = root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" })
            if dir then
              on_dir(dir)
            end
          end,
          single_file_support = false,
        },
        intelephense = {
          root_dir = function(bufnr, on_dir)
            on_dir(root(bufnr, {
              "composer.json",
              ".git",
            }) or vim.fn.getcwd())
          end,
          single_file_support = true,
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        marksman = {},
        pyright = {
          root_dir = function(bufnr, on_dir)
            on_dir(root(bufnr, {
              "pyproject.toml",
              "uv.lock",
              ".venv",
              "requirements.txt",
              "setup.py",
              "setup.cfg",
              "Pipfile",
              "pyrightconfig.json",
              ".git",
            }) or vim.fn.getcwd())
          end,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        rust_analyzer = {
          cmd = { resolve_rust_analyzer() },
          root_dir = rust_root_dir,
          single_file_support = true,
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = true,
            },
          },
        },
        ts_ls = {
          root_dir = function(bufnr, on_dir)
            local root_markers = {
              "package-lock.json",
              "yarn.lock",
              "pnpm-lock.yaml",
              "bun.lockb",
              "bun.lock",
            }

            root_markers = vim.fn.has("nvim-0.11.3") == 1
                and { root_markers, { ".git" } }
              or vim.list_extend(root_markers, { ".git" })

            local deno_root = root(bufnr, { "deno.json", "deno.jsonc" })
            local deno_lock_root = root(bufnr, { "deno.lock" })
            local project_root = root(bufnr, root_markers)

            if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
              return
            end

            if deno_root and (not project_root or #deno_root >= #project_root) then
              return
            end

            on_dir(project_root or vim.fn.getcwd())
          end,
          single_file_support = false,
        },
        tinymist = {},
      }

      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = lsp.capabilities()
        server_opts.on_attach = lsp.on_attach
        vim.lsp.config(server_name, server_opts)
      end

      for server_name in pairs(servers) do
        vim.lsp.enable(server_name)
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          {
            name = "lazydev",
            group_index = 0,
          },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      format_on_save = function()
        return {
          timeout_ms = 1000,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier" },
        python = { "ruff_format", "black" },
        rust = { "rustfmt" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        typst = { "typstyle" },
      },
    },
  },
}
