local Window = require("windui.window")

---@param opts { prompt?: string, default?: string, highlight?: fun(line: string): [integer, integer, string][]? }
---@param on_confirm fun(value: string)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
  local position = "center"
  local prompt = Window.new {
    height = 1,
    col = 10,
    border = "rounded",
    width = opts.default and #opts.default + 4 or nil,
    title = opts.prompt and " " .. opts.prompt,
    title_pos = opts.prompt and "center",
  }
  local minw = 1
  if opts.prompt then
    minw = #opts.prompt + 4
  end
  prompt.after_open = function(self)
    if opts.default then
      vim.api.nvim_set_current_line(opts.default)
    end
    local line = opts.default or vim.api.nvim_get_current_line()
    if #line + 4 < vim.o.columns then
      local w = #line + 4
      self:animate(0.1, 120, self.state:clone({ width = w < minw and minw or w }):move_to(position))
    else
      self:animate(0.1, 120, self.state:clone({ width = vim.o.columns - 2 }):move_to(position))
    end
    vim.cmd("startinsert!")
  end
  prompt.before_close = function(_, close)
    vim.cmd.stopinsert()
    close()
  end

  prompt:map("i", "<ESC>", function() prompt:close(true) end)
  prompt:map("i", "<CR>", function()
    vim.cmd.stopinsert()
    if on_confirm then
      on_confirm(vim.trim(vim.api.nvim_get_current_line()))
    end
    prompt:close(true)
  end)

  prompt:map("i", "<M-Up>", function()
    position = ({
      left = "top_left",
      center = "top",
      right = "top_right",
      bottom_left = "left",
      bottom = "center",
      bottom_right = "right",
    })[position] or position
    prompt:animate(0.1, 120, prompt.state:move_to(position))
  end)
  prompt:map("i", "<M-Down>", function()
    position = ({
      top_left = "left",
      top = "center",
      top_right = "right",
      left = "bottom_left",
      center = "bottom",
      right = "bottom_right",
    })[position] or position
    prompt:animate(0.1, 120, prompt.state:move_to(position))
  end)
  prompt:map("i", "<M-Left>", function()
    position = ({
      top = "top_left",
      top_right = "top",
      center = "left",
      right = "center",
      bottom = "bottom_left",
      bottom_right = "bottom",
    })[position] or position
    prompt:animate(0.1, 120, prompt.state:move_to(position))
  end)
  prompt:map("i", "<M-Right>", function()
    position = ({
      top_left = "top",
      top = "top_right",
      left = "center",
      center = "right",
      bottom_left = "bottom",
      bottom = "bottom_right",
    })[position] or position
    prompt:animate(0.1, 120, prompt.state:move_to(position))
  end)
  prompt:on("TextChangedI", nil, function()
    local line = vim.api.nvim_get_current_line()
    if #line + 2 >= prompt.state.width and prompt.state.width + 5 < vim.o.columns then
      prompt:animate(0.1, 120, prompt.state:add({ width = 5 }):move_to(position))
    elseif #line + 10 < prompt.state.width then
      local w = #line + 5
      prompt:animate(0.1, 120, prompt.state:clone({ width = w < minw and minw or w }):move_to(position))
    end
    if opts.highlight then
      local highlights = opts.highlight(line)
      vim.api.nvim_buf_clear_namespace(prompt.buf, -1, 0, -1)
      if highlights then
        for _, hl in ipairs(highlights) do
          vim.api.nvim_buf_add_highlight(prompt.buf, 0, hl[3], 0, hl[1], hl[2])
        end
      end
    end
  end)
  prompt:open(true)
end

---@param items any[]
---@param opts { format_item?: (fun(item: any, idx: integer): string), prompt?: string }
---@param on_choice fun(item: any, idx: integer?)
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local menu = Window.new {
    title = opts.prompt,
    title_pos = opts.prompt and "center",
    width = 2,
    height = 1,
  }
  local len = 10
  if opts.prompt then len = #opts.prompt + 4 end
  local max_lines = 20
  local lines = 1
  local displays = {}
  for i, item in ipairs(items) do
    local txt = (opts.format_item or tostring)(item, i)
    if #txt > len then len = #txt + 2 end
    if lines < max_lines then
      lines = lines + 1
    end
    displays[i] = txt
  end

  menu.before_close = function(self, close)
    self:animate(0.2, 120, self.state:clone({ width = vim.o.columns, height = 1 }):move_to("bottom"), close)
  end
  menu.after_open = function()
    vim.cmd("normal! 0")
  end
  menu.state = menu.state:move_to("center")
  menu:map('n', '<ESC>', function() menu:close(true) end)
  menu:map('n', '<CR>', function()
    local idx = vim.api.nvim_win_get_cursor(0)[1]
    local item = items[idx]
    if item then
      menu:close(true)
      on_choice(item, idx)
    end
  end)
  menu:open(true)
  menu:animate(0.1, 120, menu.state:clone({ width = len, height = lines }):move_to("center"), function()
    vim.wo[menu.win].cursorline = true
    for i, item in ipairs(displays) do
      vim.api.nvim_buf_set_lines(menu.buf, i - 1, i, false, { item })
    end
  end)
end
