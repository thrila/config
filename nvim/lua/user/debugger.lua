local dap = require("dap")
lvim.builtin.dap.active = true

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

-- Set up DAP for JavaScript/TypeScript (ReactJS/ReactTS)
pcall(function()
  require("dap-vscode-js").setup({
    node_path = "node",                                                          -- Path to Node.js executable
    debugger_path = "home/arxade/Documents/Learning/TypeScript/vscode-js-debug", -- Mason's installation directory
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    debugger_cmd = { 'js-debug-adapter' },
    port = 8003,
  })
end)

-- Custom adapter for running tasks before starting debug
local custom_adapter = 'pwa-node-custom'
dap.adapters[custom_adapter] = function(cb, config)
  if config.preLaunchTask then
    local async = require('plenary.async')
    local notify = require('notify').async

    async.run(function()
      ---@diagnostic disable-next-line: missing-parameter
      notify('Running [' .. config.preLaunchTask .. ']').events.close()
    end, function()
      vim.fn.system(config.preLaunchTask)
      config.type = 'pwa-node'
      dap.run(config)
    end)
  end
end

-- Language configuration for ReactJS (JavaScript) and ReactTS (TypeScript)
for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
    -- React (JS and TS) configuration for debugging
    {
      name = 'Launch React App',
      type = 'pwa-node',
      request = 'launch',
      program = '${workspaceFolder}/node_modules/.bin/react-scripts', -- or equivalent React build tool
      args = { 'start' },                                             -- Use 'start' to run React app in development mode
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**' },
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      name = 'Attach to React (Node process)',
      type = 'pwa-node',
      request = 'attach',
      rootPath = '${workspaceFolder}',
      processId = require('dap.utils').pick_process,
    },
    -- Regular TypeScript file configuration for debugging
    {
      name = 'Launch TypeScript File',
      type = 'pwa-node',
      request = 'launch',
      program = '${workspaceFolder}/index.ts', -- Point to your TypeScript file
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**' },
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    -- Regular JavaScript file configuration for debugging
    {
      name = 'Launch JavaScript File',
      type = 'pwa-node',
      request = 'launch',
      program = '${workspaceFolder}/index.js', -- Point to your JavaScript file
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**' },
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
  }
end
