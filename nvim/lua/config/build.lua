local M = {}

local function root()
  return vim.fs.root(0, { "go.mod", "Cargo.toml", ".git" }) or vim.fn.getcwd()
end

local function filename() return vim.fn.expand "%:p" end
local function basename() return vim.fn.expand "%:t:r" end

local function build_term(cmd)
  require("toggleterm").exec(cmd, nil, nil, { cwd = root() })
end

function M.go_test()
  build_term "go test ./..."
end

function M.go_test_file()
  build_term("go test -v -run " .. basename() .. " ./...")
end

function M.cargo_test()
  build_term "cargo test"
end

function M.run()
  local ft = vim.bo.filetype
  if ft == "rust" then
    build_term "cargo run"
  elseif ft == "go" then
    build_term "go run " .. filename()
  else
    vim.notify("No run handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

function M.build()
  local ft = vim.bo.filetype
  if ft == "rust" then
    build_term "cargo build"
  elseif ft == "go" then
    build_term "go build ./..."
  else
    vim.notify("No build handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

function M.test()
  local ft = vim.bo.filetype
  if ft == "rust" then
    M.cargo_test()
  elseif ft == "go" then
    M.go_test()
  else
    vim.notify("No test handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

return M
