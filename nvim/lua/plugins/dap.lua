local jslangs = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

local function mason_pkg(path) return vim.fn.stdpath "data" .. "/mason/packages/" .. path end

local function rust_program()
  if vim.fn.filereadable "./.cargo/config.toml" == 1 then
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
  end
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

return {
  {
    "mfussenegger/nvim-dap",
    desc = "Debugging support for web, go, and rust",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
        },
        opts = {},
      },
    },
    keys = {
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
        desc = "Breakpoint Condition",
      },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Go Debug Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Go Debug Last Test" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup {}
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open {} end
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      require("nvim-dap-virtual-text").setup {}

      local js_debug = mason_pkg "js-debug-adapter/js-debug/src/dapDebugServer.js"
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug, "${port}" },
        },
      }
      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug, "${port}" },
        },
      }

      for _, language in ipairs(jslangs) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process (Node)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Next.js (npm run dev)",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch web app (Chrome)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest current file",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            runtimeArgs = { "./node_modules/jest/bin/jest.js", "--runInBand", "${file}" },
            console = "integratedTerminal",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest current file",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            runtimeArgs = { "./node_modules/vitest/vitest.mjs", "run", "${file}" },
            console = "integratedTerminal",
          },
        }
      end

      local codelldb_path = mason_pkg "codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = rust_program,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      require("dap-go").setup {
        delve = {
          path = mason_pkg "delve/dlv",
        },
      }

      -- Normalize VS Code "node-terminal" launch configs into pwa-node
      local function normalize_launch_config(config)
        if config.type ~= "node-terminal" then return config end
        local cmd = config.command
        if not cmd then return config end

        local parts = {}
        if type(cmd) == "string" then
          parts = vim.split(cmd, "%s+", { trimempty = true })
        elseif type(cmd) == "table" then
          parts = cmd
        end

        if #parts == 0 then return config end

        local normalized = vim.deepcopy(config)
        normalized.type = "pwa-node"
        normalized.request = normalized.request or "launch"
        normalized.runtimeExecutable = parts[1]
        normalized.runtimeArgs = vim.list_slice(parts, 2)
        normalized.console = normalized.console or "integratedTerminal"
        normalized.command = nil
        return normalized
      end

      dap.providers.configs["dap.launch.json"] = function()
        local ok, configs = pcall(require("dap.ext.vscode").getconfigs)
        if not ok then
          local msg = "Can't get configurations from launch.json:\n%s" .. configs
          vim.notify_once(msg, vim.log.levels.WARN, { title = "DAP" })
          return {}
        end
        return vim.tbl_map(normalize_launch_config, configs)
      end


      local dap_sign_definitions = {
        DapStopped = { text = "▶", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" },
        DapBreakpoint = { text = "", texthl = "DiagnosticError" },
        DapBreakpointCondition = { text = "", texthl = "DiagnosticInfo" },
        DapBreakpointRejected = { text = "", texthl = "DiagnosticError" },
        DapLogPoint = { text = "◆", texthl = "DiagnosticHint" },
      }

      for name, definition in pairs(dap_sign_definitions) do
        vim.fn.sign_define(name, definition)
      end

      require("core.dap_persistence").setup()
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = "rust",
  },
}
