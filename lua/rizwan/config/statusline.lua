local M = {}
local devicon = require("nvim-web-devicons")
local c = require("onedark.colors")
local icext = devicon.get_icons_by_extension()

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

---@param name string
---@param opt vim.api.keyset.highlight
---@return any
local function shl(name, opt)
  vim.api.nvim_set_hl(0, name, opt)
  return name
end

local mode_color = {
  n = c.green,
  v = c.purple,
  V = c.purple,
  ["\22"] = c.purple,
  s = c.cyan,
  S = c.cyan,
  ["\19"] = c.cyan,
  i = c.blue,
  R = c.red,
  c = c.green,
  r = hl("Question").fg,
  t = c.green,
  ["!"] = c.yellow,
}

local mode_name = {
  n = " Normal ",
  no = " OpPend ",
  nov = " OpPendCh ",
  noV = " OpPendLn ",
  ["no\22"] = " OpPendBlk ",
  niI = " I->Normal ",
  niR = " R->Normal ",
  niV = " V->Normal ",
  nt = " NormTerm ",
  ntT = " T->Normal ",
  v = " Visual ",
  vs = " S->Visual ",
  V = " VisLine ",
  Vs = " S->VisLine ",
  ["\22"] = " VisBlk ",
  ["\22s"] = " S->VisBlk ",
  s = " Select ",
  S = " SelLine ",
  ["\19"] = " SelBlk ",
  i = " Insert ",
  ic = " InsComp ",
  ix = " Ins<C-x> ",
  R = " Replace ",
  Rc = " ReplComp ",
  Rx = " Repl<C-x> ",
  Rv = " VirtRepl ",
  Rvc = " VirtReplComp ",
  Rvx = " VirtRepl<C-x> ",
  c = " Command ",
  cr = " CommOver ",
  cv = " VimEx ",
  cvr = " VxOver ",
  r = " HEPrompt ",
  rm = " MorePrompt ",
  ["r?"] = " Confirm ",
  t = " Terminal ",
  ["!"] = " Extern ",
}

local lsp_clients_color = {
  lua_ls = icext.lua.color,
  taplo = icext.toml.color,
  intelephense = icext.php.color,
  rust_analyzer = icext.rs.color,
  html = icext.html.color,
  cssls = icext.css.color,
  emmet_ls = c.green,
  jsonls = icext.json.color,
  ccls = icext.c.color,
  gopls = icext.go.color,
  tsserver = icext.ts.color,
}

local lsp_clients_icon = {
  lua_ls = "󰢱 ",
  taplo = " ",
  intelephense = " ",
  rust_analyzer = " ",
  html = " ",
  cssls = " ",
  jsonls = " ",
  ccls = " ",
  gopls = " ",
  tsserver = " ",
}

function M.Mode()
  local mode = vim.fn.mode(1)
  local modec = mode_color[mode:sub(1, 1)]
  local title = " " .. mode_name[mode]
  local txt = "%#" ..
      shl("StlMode", { fg = c.black, bg = modec }) ..
      "#" .. title .. "%#" .. shl("StlModeReverse", { fg = modec, bg = hl("Normal").bg }) .. "#"
  return txt
end

function M.File(buf)
  if buf == 0 then buf = vim.api.nvim_get_current_buf() end
  local fn = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
  local ft = vim.filetype.match { filename = fn }
  local icon_ft, icon_hl = devicon.get_icon_by_filetype(ft, { default = true })

  local rev_file_hl = shl("StlFileIconReverse" .. buf, { fg = c.black, bg = hl(icon_hl).fg })
  local txt = "%#" ..
      shl("StlFileSide" .. buf, { fg = hl(icon_hl).fg, bg = hl("Normal").bg }) ..
      "#%#" .. rev_file_hl .. "# " .. icon_ft .. " "
  txt = txt .. "%#" .. shl("StlFileIcon" .. buf, { fg = hl(icon_hl).fg, bg = c.black }) .. "#"
  txt = txt .. "%#StlFileIcon" .. buf .. "# " .. buf .. ":" .. (fn == "" and "no_name" or fn) .. " "

  local ro = vim.bo[buf].readonly or not vim.bo[buf].modifiable
  local ch = vim.bo[buf].modified
  local col = "#989898"
  local icon = "󰦨 "
  if ro then
    col = c.orange
    icon = " "
  elseif ch then
    col = c.green
    icon = " "
  end
  txt = txt .. "%#" .. shl("StlNormal", { fg = hl("FloatBorder").fg, bg = c.black }) .. "# "
  txt = txt .. "%#" .. shl("StlFilePermission" .. buf, { fg = col, bg = c.black }) .. "#" .. icon
  txt = txt .. "%#" .. shl("StlFileEnd" .. buf, { fg = c.black, bg = hl("Normal").bg }) .. "#"
  return txt
end

function M.Location()
  local linec = #vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pos = vim.api.nvim_win_get_cursor(0)
  local curl, ccol = pos[1], tostring(pos[2] + 1)
  local perc = math.floor(curl / linec * 100)
  while #ccol < 3 do
    ccol = " " .. ccol
  end
  local txt = "%#" .. shl("StlLocationStart", { fg = c.black, bg = hl("Normal").bg }) .. "#%#StlNormal# (%#"
  txt = txt .. shl("StlLocationLineCur", { fg = hl("TSRainbowGreen").fg, bg = c.black }) .. "#"
  txt = txt .. curl .. "%#StlNormal#/%#" .. shl("StlLocationLineMax", { fg = hl("TSRainbowRed").fg, bg = c.black })
  txt = txt .. "#" .. linec .. "%#StlNormal#):%#"
  txt = txt .. shl("StlLocationColCur", { fg = hl("TSRainbowBlue").fg, bg = c.black })
  txt = txt .. "#" .. ccol .. "%#StlNormal# %#"
  txt = txt .. shl("StlLocationPercentReverse", { fg = hl("TSRainbowOrange").fg, bg = c.black }) .. "#%#"
  txt = txt .. shl("StlLocationPercent", { fg = c.black, bg = hl("TSRainbowOrange").fg }) .. "# " .. perc .. "%% "
  return txt
end

function M.Lsp()
  local txt = "%#" .. shl("StlLspSide", { fg = c.black, bg = hl("Normal").bg }) .. "#%#StlNormal#LSP%#StlLspSide#"
  for i, lsp in ipairs(vim.lsp.get_clients()) do
    local lspcol = lsp_clients_color[lsp.name] or hl("FloatBorder").fg
    local lspicon = lsp_clients_icon[lsp.name] or " "
    txt = txt .. "%#" .. shl("StlLspClientsSide" .. i, { fg = lspcol, bg = hl("Normal").bg }) .. "#%#"
    txt = txt .. shl("StlLspClientsMain" .. lsp.id, { fg = c.black, bg = lspcol })
    txt = txt .. "#" .. lspicon .. lsp.name .. ":" .. lsp.id .. "%#StlLspClientsSide" .. i .. "#"
  end
  return txt
end

function M.Diagnostic()
  local txt = ""
  local hint, info, warn, err = 0, 0, 0, 0
  local diags = vim.diagnostic.get(0)
  for _, diag in ipairs(diags) do
    if diag.severity == vim.diagnostic.severity.HINT then
      hint = hint + 1
    elseif diag.severity == vim.diagnostic.severity.INFO then
      info = info + 1
    elseif diag.severity == vim.diagnostic.severity.WARN then
      warn = warn + 1
    elseif diag.severity == vim.diagnostic.severity.ERROR then
      err = err + 1
    end
  end
  if hint > 0 then
    txt = txt .. "%#" .. shl("StlDiagHintSide", { fg = hl("DiagnosticHint").fg, bg = hl("Normal").bg }) .. "#"
    txt = txt ..
        "%#" ..
        shl("StlDiagHintMain", { fg = c.black, bg = hl("DiagnosticHint").fg }) .. "# " .. hint .. "%#StlDiagHintSide#"
  end
  if info > 0 then
    txt = txt .. "%#" .. shl("StlDiagInfoSide", { fg = hl("DiagnosticInfo").fg, bg = hl("Normal").bg }) .. "#"
    txt = txt ..
        "%#" ..
        shl("StlDiagInfoMain", { fg = c.black, bg = hl("DiagnosticInfo").fg }) .. "# " .. info .. "%#StlDiagInfoSide#"
  end
  if warn > 0 then
    txt = txt .. "%#" .. shl("StlDiagWarnSide", { fg = hl("DiagnosticWarn").fg, bg = hl("Normal").bg }) .. "#"
    txt = txt ..
        "%#" ..
        shl("StlDiagWarnMain", { fg = c.black, bg = hl("DiagnosticWarn").fg }) .. "# " .. warn .. "%#StlDiagWarnSide#"
  end
  if err > 0 then
    txt = txt .. "%#" .. shl("StlDiagErrSide", { fg = hl("DiagnosticError").fg, bg = hl("Normal").bg }) .. "#"
    txt = txt ..
        "%#" ..
        shl("StlDiagErrMain", { fg = c.black, bg = hl("DiagnosticError").fg }) .. "# " .. err .. "%#StlDiagErrSide#"
  end
  return txt
end

function M.Git()
  local txt = "%#" .. shl("StlGitSide", { fg = c.orange, bg = hl("Normal").bg }) .. "#%#"
  txt = txt .. shl("StlGit", { bg = c.orange, fg = c.black }) .. "#  "
  txt = txt .. vim.g.branch_name .. " %#StlGitSide#"
  return txt
end

function M.InfoBar()
  local txt = "%#" .. shl("StlInfoBarSide", { bg = hl("Normal").bg, fg = c.black }) .. "#%#"
  local msg = vim.g.statusline_message
  if msg then
    local timer = vim.loop.new_timer()
    timer:start(5000, 0, vim.schedule_wrap(function()
      if vim.g.statusline_message == msg then
        vim.g.statusline_message = nil
        vim.cmd.redraws()
      end
    end))
  end
  txt = txt .. shl("StlInfoBar", { bg = c.black, fg = c.orange }) .. "#%= %f"
  txt = txt ..
  (msg and (" %#" .. shl("StlMessage", { fg = c.blue, bg = c.black }) .. "#" .. msg .. "%#StlInfoBar#") or "") ..
  "%= %#StlInfoBarSide#"
  return txt
end

function M.get()
  local left = M.Mode() .. M.File(0)
  if vim.fs.root(0, { ".git" }) then
    left = left .. M.Git()
  end
  local right = M.Location()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    right = M.Lsp() .. right
  end
  local diags = vim.diagnostic.get(0)
  if #diags > 0 then
    right = M.Diagnostic() .. right
  end
  return left .. M.InfoBar() .. right
end

return M
