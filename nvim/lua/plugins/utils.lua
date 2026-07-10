return {
  {
    "wakatime/vim-wakatime",
    event = "CursorHold",
    init = function()
      vim.g.wakatime_disable_command_line = 1
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        background_colour = "#282828",
        render = "compact",
        stages = "fade_in_slide_out",
        timeout = 2500,
        top_down = false,
      })
      vim.notify = notify
    end,
  },
}
