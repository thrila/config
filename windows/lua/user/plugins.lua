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
  -- { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "nvim-neotest/neotest" },
  { "loctvl842/monokai-pro.nvim" },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    -- build = "npm install --legacy-peer-deps && npm run compile",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle ",
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
}
