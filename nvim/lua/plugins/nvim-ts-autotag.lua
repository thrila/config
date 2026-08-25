return {
  "windwp/nvim-ts-autotag",
  enabled = true,
  event = "BufReadPost",
  ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "tsx" },
  opts = function()
    require("nvim-ts-autotag").setup {
      enable_close = true, -- Auto-close tags
      enable_rename = true, -- Auto-rename pairs
      enable_close_on_slash = true, -- Enable auto-close on trailing `</`
    }
  end,
}
