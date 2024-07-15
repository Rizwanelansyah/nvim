---@diagnostic disable: duplicate-set-field
local Window = require("windui.window")
local Menu = require("windui.menu")
local Item = require("windui.item")
local devicon = require("nvim-web-devicons")

vim.ui.input = function(opts, on_value)
  local w = math.floor(vim.o.columns / 2)
  local h = 1
  local prompt = Window.new {
    height = h,
    width = w,
    title = opts.prompt,
    title_pos = opts.prompt and "center",
  }
  prompt.state = prompt.state:move_to("bottom")
  prompt.opt.win.wrap = true

  prompt.before_close = function(self, close)
    vim.cmd.stopinsert()
    prompt:animate(0.1, 120, prompt.state:move_to("bottom"), close)
  end

  prompt:map('i', '<ESC>', function()
    prompt:close(true)
  end)
  prompt:map("i", '<CR>', function()
    local line = vim.api.nvim_get_current_line()
    prompt:close(true)
    if on_value then
      on_value(line)
    end
  end)
  prompt:on("TextChangedI", nil, function()
    local line = vim.api.nvim_get_current_line()
    if #line + 5 > w * h then
      h = h + 1
      prompt:animate(0.05, 120, prompt.state:clone({ height = h }):move_to("center"))
    end
  end)

  prompt:open(true)
  if opts.default then
    vim.api.nvim_set_current_line(opts.default)
  end
  prompt:animate(0.1, 120, prompt.state:move_to("center"))
  vim.cmd("startinsert!")
end

vim.ui.select = function(items, opts, on_value)
  local menu = Menu.new({
    height = 10,
    width = math.floor(vim.o.columns / 2),
    title = opts.prompt,
    title_pos = opts.prompt and "center",
  }, vim.tbl_map(function(value)
    return Item.new(value, opts.format_item and opts.format_item(value) or tostring(value))
  end, items), opts.prompt)
  menu.on_choice = function(_, value)
    if on_value then
      on_value(value)
    end
  end
  menu.state = menu.state:move_to("bottom")
  menu.before_close = function(_, close)
    menu:animate(0.1, 120, menu.state:move_to("bottom"), close)
  end

  menu:open(true)
  menu:animate(0.1, 120, menu.state:move_to("center"))
end

local function buflist()
  local curbuf = vim.api.nvim_get_current_buf()
  local curwin = vim.api.nvim_get_current_win()
  local buffers = vim.api.nvim_list_bufs()
  buffers = vim.tbl_filter(function(value)
    local name = vim.api.nvim_buf_get_name(value)
    return vim.fn.buflisted(value) == 1 and name ~= ""
  end, buffers)
  buffers = vim.tbl_map(function(value)
    local name = vim.api.nvim_buf_get_name(value)
    local ft = vim.filetype.match { filename = vim.fs.basename(name) }
    local icon, hl = devicon.get_icon_by_filetype(ft, { default = true })
    if vim.env.HOME then
      name = name:gsub(vim.env.HOME, "~")
    end
    if vim.env.PREFIX then
      name = name:gsub(vim.env.PREFIX, "$PREFIX")
    end
    return Item.new(value, {
      { "  ",         "NormalFloat" },
      { icon,         hl },
      { "  " .. name, "NormalFloat" },
    })
  end, buffers)

  local menu = Menu.new({
    width = math.floor(vim.o.columns / 1.5),
    height = 10,
    title = "[ Buffer List ]",
    title_pos = "center",
  }, buffers, "Select Buffers")

  menu.on_choice = function(_, value)
    vim.api.nvim_win_set_buf(curwin, value)
  end
  menu.state = menu.state:move_to("bottom")
  menu.before_close = function(_, close)
    menu:animate(0.1, 120, menu.state:move_to("bottom"), close)
  end
  menu:on('CursorMoved', nil, function()
    local item = menu:get_item()
    if item and item.class_name == Item.class_name then
      vim.api.nvim_win_set_buf(curwin, item.value)
    end
  end)
  menu:map('n', '<ESC>', function()
    menu:close(true)
    vim.api.nvim_win_set_buf(curwin, curbuf)
  end)
  menu:map('n', 'd', function()
    local idx = vim.api.nvim_win_get_cursor(menu.win)[1]
    local item = menu.items[idx]
    local other = menu.items[idx - 1]
    other = other or menu.items[idx + 1]
    if other and other.class_name == Item.class_name then
      vim.api.nvim_win_set_buf(curwin, other.value)
    end
    if item and item.class_name == Item.class_name then
      vim.cmd("bdelete! " .. item.value)
    end
    table.remove(menu.items, idx)
    if #menu.items == 0 then
      menu:close(true)
      return
    end
    menu:update()
  end)

  menu:open(true)
  menu:set_selected(curbuf)
  menu:animate(0.1, 120, menu.state:move_to("center"))
end
vim.ui.buflist = buflist
vim.keymap.set('n', '<leader>bc', buflist)
