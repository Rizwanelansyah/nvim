local M = {}
local stl = require("rizwan.config.statusline")
local c = require("onedark.colors")

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

local function shl(name, opt)
  vim.api.nvim_set_hl(0, name, opt)
  return name
end

function M.get()
  local txt = "%#Normal#"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 0 then goto next end
    local iscur = vim.api.nvim_get_current_buf() == buf
    if iscur then
      txt = txt .. stl.File(buf)
    else
      local bg = hl("Normal").fg
      if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
        bg = c.yellow
      elseif vim.bo[buf].modified then
        bg = c.green
      end
      txt = txt .. "%#" .. shl("TabLineFileSide" .. buf, { fg = c.black, bg = hl("Normal").bg }) .. "#"
      txt = txt .. "%#" .. shl("TabLineFile" .. buf, { fg = bg, bg = c.black }) .. "# " .. vim.fs.basename(vim.api.nvim_buf_get_name(buf))
      txt = txt .. " %#TabLineFileSide" .. buf .. "#"
    end
    ::next::
  end
  return txt .. "%#Normal#"
end

return M
