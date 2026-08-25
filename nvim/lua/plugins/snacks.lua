return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
      },
      terminal = { enabled = false },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function() Snacks.gitbrowse() end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local gh_available = vim.fn.executable("gh") == 1
            local cmds = {
              {
                title = "Open Issues",
                cmd = "gh issue list -L 3 2>/dev/null || true",
                key = "i",
                action = function() vim.fn.jobstart("gh issue list --web", { detach = true }) end,
                icon = " ",
                height = 7,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 3 2>/dev/null || true",
                key = "P",
                action = function() vim.fn.jobstart("gh pr list --web", { detach = true }) end,
                height = 7,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(
              function(cmd)
                return vim.tbl_extend("force", {
                  pane = 2,
                  section = "terminal",
                  enabled = in_git and gh_available,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end,
              cmds
            )
          end,
          { section = "startup" },
        },
      },
      explorer = {
        enabled = false,
        layout = { cycle = false },
      },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = "telescope", -- defaults to this layout unless overridden
          cycle = true,
        },
        sources = {
          notifications = {
            win = {
              preview = {
                wo = {
                  wrap = true,
                  linebreak = true,
                  breakindent = true,
                },
              },
            },
          },
        },
        telescope = {
          reverse = true,
          layout = {
            box = "horizontal",
            backdrop = false,
            width = 0.8,
            height = 0.9,
            border = "none",
            {
              box = "vertical",
              { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
              { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
            },
            { win = "preview", title = "{preview:Preview}", width = 0.45, border = "rounded", title_pos = "center" },
          },
        },
      },
      notifier = { enabled = true, timeout = 3000, top_down = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = {
            wrap = true,
          }, -- Wrap notifications
        },
      },
    },

    keys = {
      -- Top Pickers & Explorer
      -- {"<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files",},
      { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- { "<leader>ee", function() Snacks.explorer() end, desc = "File Explorer" },

      -- Find (Telescope)
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      {
        "<leader>fc",
        function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end,
        desc = "Find Config File",
      },

      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      {
        "<leader>sw",
        function() Snacks.picker.grep_word() end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },

      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

      -- Lazygit & Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>glg", function() Snacks.lazygit.log() end, desc = "Lazygit logs" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>glG", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },

      -- Diagnostics
      -- { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },

      -- Quickfix
      { "<leader>qfl", function() Snacks.picker.qflist() end, desc = "Quickfix List" },

      -- Others
      { "<leader>Z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Toggle mappings
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.line_number():map "<leader>ul"
          Snacks.toggle.inlay_hints():map "<leader>uh"
        end,
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    optional = true,
    keys = {
      {
        "<leader>xt",
        function() require("snacks").picker.todo_comments() end,
        desc = "Todo",
      },
      {
        "<leader>xT",
        function()
          require("snacks").picker.todo_comments {
            keywords = {
              "TODO",
              "FIX",
              "FIXME",
            },
          }
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
