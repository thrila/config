local M = {}

local file = vim.fn.stdpath "state" .. "/dap-breakpoints.json"

local function read_file(path)
  if vim.fn.filereadable(path) ~= 1 then return nil end
  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then return nil end
  return table.concat(lines, "\n")
end

local function write_file(path, content)
  local dir = vim.fn.fnamemodify(path, ":h")
  vim.fn.mkdir(dir, "p")
  vim.fn.writefile({ content }, path)
end

function M.save()
  local dap_bps = require("dap.breakpoints").get()
  local out = {}

  for bufnr, bps in pairs(dap_bps) do
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path ~= "" and vim.fn.filereadable(path) == 1 then
      out[path] = {}
      for _, bp in ipairs(bps) do
        table.insert(out[path], {
          line = bp.line,
          condition = bp.condition,
          hitCondition = bp.hitCondition,
          logMessage = bp.logMessage,
        })
      end
      if #out[path] == 0 then out[path] = nil end
    end
  end

  local ok, encoded = pcall(vim.json.encode, out)
  if not ok then
    vim.notify("Failed to encode DAP breakpoints", vim.log.levels.WARN)
    return
  end

  write_file(file, encoded)
end

function M.load()
  local content = read_file(file)
  if not content then return end

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then return end

  local dap = require "dap"
  local bps = require "dap.breakpoints"

  dap.clear_breakpoints()
  for path, entries in pairs(decoded) do
    if type(path) == "string" and type(entries) == "table" then
      local bufnr = vim.fn.bufnr(path, true)
      for _, entry in ipairs(entries) do
        if type(entry) == "table" and type(entry.line) == "number" then
          bps.set({
            condition = entry.condition,
            hit_condition = entry.hitCondition,
            log_message = entry.logMessage,
            replace = true,
          }, bufnr, entry.line)
        end
      end
    end
  end
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("DapPersistence", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup,
    callback = function() M.save() end,
  })

  vim.api.nvim_create_user_command("DapBreakpointsSave", function() M.save() end, {
    desc = "Save DAP breakpoints",
  })
  vim.api.nvim_create_user_command("DapBreakpointsLoad", function() M.load() end, {
    desc = "Load DAP breakpoints",
  })

  M.load()
end

return M
