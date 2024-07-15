vim.cmd [[set statusline=%!v:lua.require'minvim.config.statusline'.get()]]
vim.cmd [[set winbar=%!v:lua.require'minvim.config.winbar'.get()]]

local map = vim.keymap.set
map('n', '<leader>bn', "<CMD>bnext<CR>")
map('n', '<leader>bv', "<CMD>bprevious<CR>")
map('n', '<leader>bd', "<CMD>bdelete<CR>")
map('n', '<leader>bo', function()
  local buffers = vim.api.nvim_list_bufs()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(buffers) do
    if vim.fn.buflisted(buf) == 1 and buf ~= current then
      vim.cmd("bdelete! " .. buf)
    end
  end
end)

---@param name string
---@return vim.api.keyset.hl_info
local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, create = false })
end

local stl = require("minvim.config.statusline")
local color = require("onedark.palette")[ONEDARK_STYLE]

local mode_name = {
  n = "Normal",
  no = "OpPend",
  nov = "OpPendCh",
  noV = "OpPendLn",
  ["no\22"] = "OpPendBlk",
  niI = "I->Normal",
  niR = "R->Normal",
  niV = "V->Normal",
  nt = "NormTerm",
  ntT = "T->Normal",
  v = "Visual",
  vs = "S->Visual",
  V = "VisLine",
  Vs = "S->VisLine",
  ["\22"] = "VisBlk",
  ["\22s"] = "S->VisBlk",
  s = "Select",
  S = "SelLine",
  ["\19"] = "SelBlk",
  i = "Insert",
  ic = "InsComp",
  ix = "Ins<C-x>",
  R = "Replace",
  Rc = "ReplComp",
  Rx = "Repl<C-x>",
  Rv = "VirtRepl",
  Rvc = "VirtReplComp",
  Rvx = "VirtRepl<C-x>",
  c = "Command",
  cr = "CommOver",
  cv = "VimEx",
  cvr = "VxOver",
  r = "HEPrompt",
  rm = "MorePrompt",
  ["r?"] = "Confirm",
  t = "Terminal",
  ["!"] = "Extern",
}

stl.opts.bg = hl("Normal").bg or color.bg0
stl.opts.fg = hl("Normal").fg
stl.opts.accent = color.blue
stl.opts.inv_buf_ft = true
stl.opts.inv_buf_name = false
stl.opts.inv_percent = true

local mode_color = {
  n = color.green,
  v = color.purple,
  V = color.dark_purple,
  ["\22"] = color.dark_purple,
  s = color.cyan,
  S = color.dark_cyan,
  ["\19"] = color.dark_cyan,
  i = color.blue,
  R = color.red,
  c = color.yellow,
  r = color.bg_blue,
  t = color.green,
  ["!"] = color.yellow,
}

stl.opts.mode = function(mode)
  return mode_name[mode], mode_color[mode:sub(1, 1)] or "#ffffff", color.black
end

stl.opts.buf_normal = color.light0
stl.opts.buf_mod = color.green
stl.opts.buf_ro = color.yellow
stl.opts.cur_line = color.green
stl.opts.max_line = color.red
stl.opts.cur_col = color.blue
stl.opts.percent = color.yellow
stl.opts.lsp = color.bg_blue

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function ()
    vim.cmd("redraws")
  end
})

local file = vim.env.PWD .. "/nvconf.lua"
vim.print(file)
if vim.fn.filereadable(file) == 1 then
  vim.cmd("source " .. file)
end
