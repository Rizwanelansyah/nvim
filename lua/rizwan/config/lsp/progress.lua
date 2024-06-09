vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(opts)
    local value = opts.data.params.value
    if value.kind == "end" then
      vim.g.statusline_message = "LSP: Complete " .. value.title
      vim.cmd.redraws()
      local timer = vim.loop.new_timer()
      timer:start(2000, 0, vim.schedule_wrap(function()
        vim.g.statusline_message = nil
        vim.cmd.redraws()
      end))
    else
      vim.g.statusline_message = "LSP" .. (value.percentage and "(" .. tostring(value.percentage) .. "%%)" or "") .. ": " .. value.title .. (value.message and (" (" .. value.message .. ") ") or "")
      vim.cmd.redraws()
    end
  end,
})
