return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require "lualine"
    local lazy_status = require "lazy.status" -- to configure lazy pending updates count

    local colors = {
      color0 = "#092236",
      color1 = "#ff5874",
      color2 = "#c3ccdc",
      color3 = "#1c1e26",
      color6 = "#a1aab8",
      color7 = "#828697",
      color8 = "#ae81ff",
    }

    local mode = {
      "mode",
      fmt = function(str)
        -- return ' '
        -- displays only the first character of the mode
        return " " .. str
      end,
    }

    local diff = {
      "diff",
      colored = true,
      symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
      -- cond = hide_in_width,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 0,
    }

    local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

    lualine.setup {
      icons_enabled = true,
      theme = "auto",
      options = {
        -- theme = my_lualine_theme,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "|", right = "" },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch },
        lualine_c = { diff, filename, "diagnostics" },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          -- { "encoding",},
          -- { "fileformat" },
          { "filetype" },
        },
      },
    }
  end,
}
