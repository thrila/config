return {
  {
    "nvim-neotest/neotest",
    cmd = {
      "Neotest",
      "NeotestRun",
      "NeotestSummary",
      "NeotestOutput",
      "NeotestOutputPanel",
    },
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      {
        "nvim-neotest/nvim-nio",
        lazy = false,
      },
      "nvim-tree/nvim-web-devicons",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-python")({}),
          require("neotest-rust")({}),
        },
      })
    end,
  },
}
