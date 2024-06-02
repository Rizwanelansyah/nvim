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
    txt = txt .. stl.File(buf, iscur)
    ::next::
  end
  return txt .. "%#Normal#"
end

return M
