local M = {}

local term = require("config.terminal")

local function root()
  return vim.fs.root(0, {
    "Cargo.toml", "Makefile", "CMakeLists.txt",
    "stack.yaml", "*.cabal", "cabal.project", "package.yaml",
    ".git",
  }) or vim.fn.getcwd()
end

local function filename()
  return vim.fn.expand("%:p")
end

local function basename()
  return vim.fn.expand("%:t:r")
end

local function detect_c_compiler()
  for _, cc in ipairs({ "clang", "gcc", "cc" }) do
    if vim.fn.executable(cc) == 1 then return cc end
  end
  return "gcc"
end

local function detect_cpp_compiler()
  for _, cxx in ipairs({ "clang++", "g++", "c++" }) do
    if vim.fn.executable(cxx) == 1 then return cxx end
  end
  return "g++"
end

local function build_term(cmd)
  term.run(cmd, { cwd = root(), delay_close = true })
end

-- ── Rust ───────────────────────────────────────────────────────────────────

function M.cargo_run()
  build_term("cargo run")
end

function M.cargo_build()
  build_term("cargo build")
end

function M.cargo_test()
  build_term("cargo test")
end

-- ── C / C++ ────────────────────────────────────────────────────────────────

function M.c_run()
  local cc = detect_c_compiler()
  local out = basename()
  local src = filename()
  build_term(string.format("%s -o %s %s && ./%s", cc, out, src, out))
end

function M.c_build()
  local cc = detect_c_compiler()
  local out = basename()
  local src = filename()
  build_term(string.format("%s -o %s %s", cc, out, src))
end

function M.cpp_run()
  local cxx = detect_cpp_compiler()
  local out = basename()
  local src = filename()
  build_term(string.format("%s -o %s %s && ./%s", cxx, out, src, out))
end

function M.cpp_build()
  local cxx = detect_cpp_compiler()
  local out = basename()
  local src = filename()
  build_term(string.format("%s -o %s %s", cxx, out, src))
end

-- ── Haskell ────────────────────────────────────────────────────────────────

function M.haskell_build()
  local r = root()
  if vim.fn.filereadable(r .. "/stack.yaml") == 1 then
    build_term("stack build")
  elseif vim.fn.glob(r .. "/*.cabal") ~= "" or vim.fn.filereadable(r .. "/cabal.project") == 1 then
    build_term("cabal build")
  else
    local src = filename()
    build_term("ghc -o " .. basename() .. " " .. src)
  end
end

function M.haskell_run()
  local r = root()
  if vim.fn.filereadable(r .. "/stack.yaml") == 1 then
    build_term("stack run")
  elseif vim.fn.glob(r .. "/*.cabal") ~= "" or vim.fn.filereadable(r .. "/cabal.project") == 1 then
    build_term("cabal run")
  else
    local out = basename()
    build_term("./" .. out)
  end
end

function M.haskell_test()
  local r = root()
  if vim.fn.filereadable(r .. "/stack.yaml") == 1 then
    build_term("stack test")
  elseif vim.fn.glob(r .. "/*.cabal") ~= "" then
    build_term("cabal test")
  else
    vim.notify("No test runner found (need stack.yaml or *.cabal)", vim.log.levels.WARN)
  end
end

-- ── Dispatch ───────────────────────────────────────────────────────────────

function M.run()
  local ft = vim.bo.filetype
  if ft == "rust" then
    M.cargo_run()
  elseif ft == "c" then
    M.c_run()
  elseif ft == "cpp" then
    M.cpp_run()
  elseif ft == "haskell" then
    M.haskell_run()
  else
    vim.notify("No run handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

function M.build()
  local ft = vim.bo.filetype
  if ft == "rust" then
    M.cargo_build()
  elseif ft == "c" then
    M.c_build()
  elseif ft == "cpp" then
    M.cpp_build()
  elseif ft == "haskell" then
    M.haskell_build()
  else
    vim.notify("No build handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

function M.test()
  local ft = vim.bo.filetype
  if ft == "rust" then
    M.cargo_test()
  elseif ft == "haskell" then
    M.haskell_test()
  else
    vim.notify("No test handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

return M
