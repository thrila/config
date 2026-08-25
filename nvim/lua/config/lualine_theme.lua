local M = {}

local function hl(name, field)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok then return nil end
  return hl[field]
end

local function color(name, field, fallback)
  local c = hl(name, field)
  if c then return string.format("#%06x", c) end
  return fallback
end

function M.get()
  return {
    normal = {
      a = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("Statement", "fg", "#6f2e2a"), bold = true },
      b = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("StatusLine", "bg", "#282828") },
      c = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("Normal", "bg", "NONE") },
    },
    insert = {
      a = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("Function", "fg", "#b8bb26"), bold = true },
    },
    visual = {
      a = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("Visual", "bg", "#6f2e2a"), bold = true },
    },
    replace = {
      a = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("DiagnosticError", "fg", "#fb4934"), bold = true },
    },
    command = {
      a = { fg = color("StatusLine", "fg", "#e1ffe5"), bg = color("Type", "fg", "#fabd2f"), bold = true },
    },
    inactive = {
      a = { fg = color("Comment", "fg", "#928374"), bg = color("Normal", "bg", "NONE") },
      b = { fg = color("Comment", "fg", "#928374"), bg = color("Normal", "bg", "NONE") },
      c = { fg = color("Comment", "fg", "#928374"), bg = color("Normal", "bg", "NONE") },
    },
  }
end

return M
