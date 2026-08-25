return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    -- { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
    -- { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical Terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating Terminal" },
    { "<leader>tg", "<cmd>lua lazygit_toggle()<cr>", desc = "Lazygit Terminal" },
    {
      "<leader>th",
      "<cmd>lua terminal_toggle('horizontal')<cr>",
      desc = "Numbered Horizontal Terminal",
    },
    {
      "<leader>tv",
      "<cmd>lua terminal_toggle('vertical')<cr>",
      desc = "Numbered Vertical Terminal",
    },
    -- Global Toggle: Toggle ALL open terminals (like VS Code Ctrl+J)
    { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle All Terminals" },
    -- Select: Use Telescope-like picker to jump between terminals
    { "<leader>ts", "<cmd>TermSelect<cr>", desc = "Select Terminal" },
  },

  config = function()
    local Terminal = require("toggleterm.terminal").Terminal

    --- Toggles a specific terminal instance (1-9) in a desired direction.
    --- @param direction string "horizontal" or "vertical"
    function _G.terminal_toggle(direction)
      -- Get the number prefix passed by the user (e.g., in "2<leader>t")
      local count = vim.v.count == 0 and 1 or vim.v.count

      -- Use the existing ToggleTerm command with the count and direction
      vim.cmd(count .. "ToggleTerm name={count} direction=" .. direction)
    end

    require("toggleterm").setup {
      size = function(term)
        if term.direction == "horizontal" then
          return 15 -- Height for horizontal split
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4 -- 40% width for vertical split
        else
          return 0.6
        end
      end,
      open_mapping = [[<c-\>]], -- Default mapping to open/close
      hide_numbers = true, -- hide the number column in toggleterm buffers
      autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      direction = "float", -- "vertical" | "horizontal" | "tab" | "float"
      close_on_exit = true, -- close the terminal window when the process exits
      clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
      shade_terminals = true,
      shading_factor = 2, -- Use a higher number for a more noticeable difference.
      -- Change the default shell. Can be a string or a function returning a string
      shell = vim.o.shell,
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = true, -- Set to true to show the terminal name in the winbar
        name_formatter = function(term)
          -- If a terminal is named (like the specialized lazygit), use that name.
          -- if term.name then return term.name end

          -- For numbered/default terminals, make the name more descriptive.
          -- Use the terminal's number (term.id) and its current command (term.command)
          -- return string.format("Terminal %d: %s", term.id, term.command or vim.o.shell)
          return string.format("Terminal %d: %s", term.id, term.command or vim.o.shell)
        end,
      },
    }
  end,
}
