local Menu = require("windui.menu")
local Item = require("windui.item")
local devicon = require("nvim-web-devicons")

return function()
  local items = {}
  local win = vim.api.nvim_get_current_win()
  local curbuf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.fn.bufname(buf)
    if vim.fn.buflisted(buf) == 1 and name ~= vim.fn.getcwd(0) then
      local txt = {}
      local icon, hl = devicon.get_icon_by_filetype(vim.filetype.match {
        filename = vim.fs.basename(name)
      }, { default = true })
      table.insert(txt, { "  ", "Normal" })
      table.insert(txt, { icon, hl })
      table.insert(txt, { "  ", "Normal" })
      table.insert(txt, { name, "Normal" })
      table.insert(items, Item.new(buf, txt))
    end
  end

  local menu = Menu.new({ width = 150, height = 20 }, items, "Quick Buf Switch")
  menu.state = menu.state:move_to("bottom")
  menu.opt.win.winhl = ""
  menu.before_close = function(_, close)
    menu:animate(0.1, 120, menu.state:clone({ width = 1, height = 1 }):move_to("bottom"), close)
  end
  menu.on_choice = function(_, item)
    vim.cmd("e " .. vim.fn.bufname(item))
  end
  menu:on("CursorMoved", nil, function()
    local item = menu:get_item()
    vim.api.nvim_win_set_buf(win, item.value)
  end)
  menu:map('n', '<ESC>', function()
    menu:close(true)
    vim.api.nvim_win_set_buf(win, curbuf)
  end)

  menu:open(true)
  menu:set_selected(curbuf)
  menu:animate(0.1, 120, menu.state:move_to("center"))
end
