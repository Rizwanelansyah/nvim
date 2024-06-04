---@param opts { prompt?: string, default?: string, highlight?: fun(line: string): [integer, integer, string][]? }
---@param on_confirm fun(value: string)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_create_augroup("UIInput", { clear = true })
  local function close()
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.api.nvim_del_augroup_by_name("UIInput")
    vim.cmd.stopinsert()
  end
  vim.api.nvim_buf_set_keymap(buf, "i", "<ESC>", "", {
    callback = close,
  })
  vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", "", {
    callback = function()
      vim.cmd.stopinsert()
      if on_confirm then
        on_confirm(vim.trim(vim.api.nvim_get_current_line()))
      end
      close()
    end
  })
  vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    col = 0,
    row = 1,
    width = vim.o.columns,
    height = 1,
    border = "rounded",
    title = opts.prompt and " " .. opts.prompt,
    title_pos = opts.prompt and "center",
    style = "minimal",
  })
  if opts.default then
    vim.api.nvim_set_current_line(opts.default)
  end
  if opts.highlight then
    vim.api.nvim_create_autocmd("TextChangedI", {
      group = "UIInput",
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local highlights = opts.highlight(line)
        vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
        if highlights then
          for _, hl in ipairs(highlights) do
            vim.api.nvim_buf_add_highlight(buf, 0, hl[3], 0, hl[1], hl[2])
          end
        end
      end
    })
  end
  vim.cmd("startinsert!")
end

---@param items any[]
---@param opts { format_item?: (fun(item: any): string), prompt?: string }
---@param on_choice fun(item: any, idx: integer?)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local format_item = opts.format_item or tostring
  local buf = vim.api.nvim_create_buf(false, true)
  local function close()
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", "", {
    callback = close,
  })
  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
    callback = function()
      local idx = vim.api.nvim_win_get_cursor(0)[1]
      local item = items[idx]
      if item then
        on_choice(item, idx)
      end
      close()
    end
  })
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    col = 0,
    row = 1,
    width = vim.o.columns,
    height = #items,
    border = "rounded",
    title = opts.prompt and " " .. opts.prompt,
    title_pos = opts.prompt and "center",
    style = "minimal",
  })
  vim.api.nvim_set_option_value("cursorline", true, { win = win })
  for i, item in ipairs(items) do
    vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { tostring(format_item(item)) })
  end
end
