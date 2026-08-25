local M = {}

local term = require("config.terminal")

local function root()
  return vim.fs.root(0, {
    "Cargo.toml", "Makefile", "CMakeLists.txt",
    "pyproject.toml", "uv.lock", "requirements.txt",
    "pom.xml", "mvnw", "build.gradle", "build.gradle.kts",
    "settings.gradle", "settings.gradle.kts", "gradlew",
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

-- ── Python ──────────────────────────────────────────────────────────────────

function M.python_test()
  build_term("uv run pytest")
end

-- ── Java (Maven / Gradle) ───────────────────────────────────────────────────

local function has_marker(dir, marker)
  return vim.fn.filereadable(dir .. "\\" .. marker) == 1
    or vim.fn.isdirectory(dir .. "\\" .. marker) == 1
end

local function is_gradle_project()
  return has_marker(root(), "build.gradle")
    or has_marker(root(), "build.gradle.kts")
    or has_marker(root(), "settings.gradle")
    or has_marker(root(), "settings.gradle.kts")
    or has_marker(root(), "gradlew")
end

local function wrapper(base)
  local dir = root()
  local suffixes = vim.g.is_windows and { ".cmd", ".bat", "" } or { "" }
  for _, suffix in ipairs(suffixes) do
    if vim.fn.filereadable(dir .. "\\" .. base .. suffix) == 1 then
      return dir .. "\\" .. base .. suffix
    end
  end
  return base
end

local function maven_cmd()
  if has_marker(root(), "mvnw") then
    return wrapper("mvnw")
  end
  return "mvn"
end

local function gradle_cmd()
  if has_marker(root(), "gradlew") then
    return wrapper("gradlew")
  end
  return "gradle"
end

function M.java_run()
  if is_gradle_project() then
    build_term(string.format("%s run", gradle_cmd()))
    return
  end
  if has_marker(root(), "pom.xml") then
    build_term(string.format("%s exec:java", maven_cmd()))
    return
  end
  build_term(string.format("java %s", filename()))
end

function M.java_build()
  if is_gradle_project() then
    build_term(string.format("%s build", gradle_cmd()))
  else
    build_term(string.format("%s package", maven_cmd()))
  end
end

function M.java_test()
  if is_gradle_project() then
    build_term(string.format("%s test", gradle_cmd()))
  else
    build_term(string.format("%s test", maven_cmd()))
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
  elseif ft == "java" then
    M.java_run()
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
  elseif ft == "java" then
    M.java_build()
  else
    vim.notify("No build handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

function M.test()
  local ft = vim.bo.filetype
  if ft == "rust" then
    M.cargo_test()
  elseif ft == "python" then
    M.python_test()
  elseif ft == "java" then
    M.java_test()
  else
    vim.notify("No test handler for filetype: " .. ft, vim.log.levels.WARN)
  end
end

return M
