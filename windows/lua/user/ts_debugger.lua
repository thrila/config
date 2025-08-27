local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "lvim/mason/")
require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = "C:/Users/Administrator/AppData/Roaming/lunarvim/site/pack/lazy/opt/vscode-js-debug",
  -- debugger_path = mason_path .. "packages/vscode-js-debug",                                    -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    -- Jest debugging
    -- {
    -- 	type = "pwa-node",
    -- 	request = "launch",
    -- 	name = "Debug Jest Tests",
    -- 	-- trace = true, -- include debugger info
    -- 	runtimeExecutable = "node",
    -- 	runtimeArgs = {
    -- 		"./node_modules/jest/bin/jest.js",
    -- 		"--runInBand",
    -- 	},
    -- 	rootPath = "${workspaceFolder}",
    -- 	cwd = "${workspaceFolder}",
    -- 	console = "integratedTerminal",
    -- 	internalConsoleOptions = "neverOpen",
    -- },
  }
end
