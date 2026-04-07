return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "soft",
      terminal_colors = true,
      transparent_mode = true,
      italic = {
        strings = false,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      overrides = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
        CursorLine = { bg = "#32302f" },
      },
    },
    config = function(_, opts)
      local transparent_groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "EndOfBuffer",
        "NormalFloat",
        "FloatBorder",
        "FloatTitle",
        "FoldColumn",
        "Folded",
        "LineNr",
        "CursorLineNr",
        "NormalSB",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineSel",
        "TabLineFill",
        "WinBar",
        "WinBarNC",
        "WinSeparator",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopePromptTitle",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
        "WhichKeyFloat",
        "LazyNormal",
        "LazyBorder",
        "OilDir",
        "OilDirIcon",
        "DashboardCenter",
        "DashboardFooter",
        "DashboardHeader",
        "DashboardPreview",
        "DashboardShortCut",
      }

      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")

      for _, group in ipairs(transparent_groups) do
        local ok, current = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok then
          current.bg = "NONE"
          current.ctermbg = "NONE"
          vim.api.nvim_set_hl(0, group, current)
        end
      end
    end,
  },
}
