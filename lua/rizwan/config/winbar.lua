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

function M.Current(buf)
  local txt = "%#" .. shl("WinBarSelBufSide", { fg = c.green, bg = hl("Normal").bg }) .. "#"
  txt = txt .. "%#" .. shl("WinBarSelBuf", { fg = c.black, bg = c.green }) .. "#Cur" .. stl.File(buf, c.green)
  txt = txt .. "%#WinBarSelBufSide#"
  return txt
end

function M.get()
  local txt = "%#Normal#"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 0 then goto next end
    local iscur = vim.api.nvim_get_current_buf() == buf
    if iscur then
      txt = txt .. M.Current(buf)
    else
      txt = txt .. stl.File(buf)
    end
    ::next::
  end
  return txt .. "%#Normal#"
end

return M
