return {
  {
    "vossenwout/guts.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("guts")

      local hl = vim.api.nvim_set_hl

      -- ── Transparency ─────────────────────────────────────────────────
      hl(0, "Normal", { bg = "NONE" })
      hl(0, "NormalNC", { bg = "NONE" })

      -- ── Visual: subtle, not loud ──────────────────────────────────────
      hl(0, "Visual", { bg = "#6f2e2a", fg = "#e1ffe5" })

      -- ── CursorLine: clearly visible ──────────────────────────────────
      hl(0, "CursorLine", { bg = "#3c3836" })
      hl(0, "CursorLineNr", { bg = "#3c3836", fg = "#fabd2f", bold = true })
    end,
  },
}
