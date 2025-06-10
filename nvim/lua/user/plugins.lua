lvim.plugins = {
  {
    "wakatime/vim-wakatime"
  },
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "mxsdev/nvim-dap-vscode-js" },
  { "nvim-neotest/neotest" },
  { "loctvl842/monokai-pro.nvim" }
}
