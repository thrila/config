local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- ── Yank highlight ─────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
  end,
})

-- ── Terminal ───────────────────────────────────────────────────────────────

local function setup_term_buf()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.scrolloff = 0
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    setup_term_buf()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  group = group,
  callback = function(ev)
    local bufnr = ev.buf
    if vim.b[bufnr].term_managed then
      return
    end
    if vim.b[bufnr].term_delay_close then
      local timer = vim.uv.new_timer()
      timer:start(2000, 0, function()
        vim.schedule(function()
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
          if timer and not timer:is_closing() then
            timer:close()
          end
        end)
      end)
    else
      vim.schedule(function()
        if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end)
    end
  end,
})

-- ── Focus / resize ─────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave" }, {
  group = group,
  callback = function()
    vim.cmd.checktime()
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
