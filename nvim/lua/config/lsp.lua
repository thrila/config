local M = {}

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  signs = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})

for type, icon in pairs({
  Error = " ",
  Warn = " ",
  Hint = "󰌶 ",
  Info = " ",
}) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

function M.capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

local function float_opts(kind)
  local is_rust = vim.bo.filetype == "rust"
  local width_ratio = is_rust and 0.72 or 0.60
  local height_ratio = is_rust and 0.45 or 0.32

  return {
    border = "rounded",
    focusable = true,
    focus_id = kind and ("lsp-" .. kind:lower()) or "lsp-float",
    max_width = math.max(72, math.floor(vim.o.columns * width_ratio)),
    max_height = math.max(12, math.floor(vim.o.lines * height_ratio)),
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
    },
    title = kind and (" " .. kind .. " ") or nil,
  }
end

local function open_line_diagnostics()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = line })

  if vim.tbl_isempty(diagnostics) then
    return false
  end

  vim.diagnostic.open_float(nil, vim.tbl_extend("force", float_opts("Diagnostics"), {
    scope = "line",
    source = "if_many",
  }))

  return true
end

function M.hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/hover",
  })

  if #clients == 0 then
    if not open_line_diagnostics() then
      vim.cmd.normal({ args = { "K" }, bang = true })
    end
    return
  end

  local params = vim.lsp.util.make_position_params(0, "utf-8")

  vim.lsp.buf_request_all(bufnr, "textDocument/hover", params, function(results)
    local lines

    for _, response in pairs(results or {}) do
      local result = response.result
      if result and result.contents then
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)

        if not vim.tbl_isempty(markdown_lines) then
          lines = markdown_lines
          break
        end
      end
    end

    if lines then
      local opts = float_opts("Hover")
      local float_bufnr = vim.lsp.util.open_floating_preview(lines, "markdown", opts)
      if float_bufnr then
        vim.bo[float_bufnr].modifiable = false
      end
      return
    end

    if not open_line_diagnostics() then
      vim.cmd.normal({ args = { "K" }, bang = true })
    end
  end)
end

function M.signature_help()
  vim.lsp.buf.signature_help(float_opts("Signature"))
end

function M.on_attach(client, bufnr)
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gr", vim.lsp.buf.references, "Go to references")
  map("gI", vim.lsp.buf.implementation, "Go to implementation")
  map("gs", M.signature_help, "Signature help")
  map("gl", vim.diagnostic.open_float, "Line diagnostics")
  map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>la", vim.lsp.buf.code_action, "Code action")
  map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
  map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("]d", vim.diagnostic.goto_next, "Next diagnostic")

  if client.server_capabilities.documentFormattingProvider then
    map("<leader>lf", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, "Format buffer")
  end
end

return M
