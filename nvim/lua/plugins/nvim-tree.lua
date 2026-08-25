local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  api.config.mappings.default_on_attach(bufnr)

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
  vim.keymap.set("n", "v", api.node.open.vertical, opts "Open Vertical Split")
  vim.keymap.set("n", "s", api.node.open.horizontal, opts "Open Horizontal Split")
  vim.keymap.set("n", "a", api.fs.create, opts "Create")
  vim.keymap.set("n", "d", api.fs.remove, opts "Delete")
  vim.keymap.set("n", "r", api.fs.rename, opts "Rename")
  vim.keymap.set("n", "y", api.fs.copy.filename, opts "Copy Name")
  vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
  vim.keymap.set("n", "C", api.fs.copy.absolute_path, opts "Copy Absolute Path")
  vim.keymap.set("n", "R", api.tree.reload, opts "Refresh")
  vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts "Toggle Hidden")
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Open Explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal in Explorer" },
    },
    config = function()
      require("nvim-tree").setup {
        on_attach = on_attach,
        reload_on_bufenter = true,
        hijack_cursor = true,
        hijack_netrw = true,
        sync_root_with_cwd = true,
        hijack_unnamed_buffer_when_opening = true,
        auto_reload_on_write = true,
        diagnostics = {
          enable = true,
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
            resize_window = true,
          },
        },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          centralize_selection = true,
          adaptive_size = false,
          side = "right",
          preserve_window_proportions = true,
          width = 40,
        },
        renderer = {
          full_name = false,
          indent_markers = {
            enable = true,
          },
          group_empty = true,
          root_folder_label = ":t",
          highlight_git = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
          git_clean = false,
          no_buffer = false,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
      }
    end,
  },
}
