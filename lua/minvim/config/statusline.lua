local M = {}
local devicon = require("nvim-web-devicons")

---@class StatuslineOptions
---@field buf_normal? string | integer
---@field buf_mod? string | integer
---@field buf_ro? string | integer
---@field inv_buf_ft? boolean
---@field bg? string | integer
---@field fg? string | integer
---@field accent? string | integer
---@field inv_buf_name? boolean,
---@field mode fun(mode: string): string, string, string?
---@field cur_line? string | integer
---@field max_line? string | integer
---@field cur_col? string | integer
---@field percent? string | integer
---@field lsp? string | integer
---@field inv_percent? boolean

---@type StatuslineOptions
M.opts = {
  buf_normal = "#ffffff",
  buf_mod = "#00ff00",
  buf_ro = "#ffee00",
  bg = "#000000",
  fg = "#ffffff",
  accent = "#0000ff",
  inv_buf_ft = false,
  inv_buf_name = false,
  cur_col = "#ffffff",
  cur_line = "#ffffff",
  max_line = "#ffffff",
  percent = "#ffffff",
  lsp = "#0000ff",
  inv_percent = false,
  mode = function(mode)
    return mode:upper(), "#ff00ff"
  end,
}

---@param name string
---@param keyset vim.api.keyset.highlight
---@return string
local function set_hl(name, keyset)
  vim.api.nvim_set_hl(0, name, keyset)
  return name
end

---@param name string
---@return vim.api.keyset.hl_info
local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, create = false })
end

function M.BufStat(buffer)
  buffer = buffer or vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buffer)
  local filename = vim.fs.basename(name)
  name = (not name or name == "") and "[No Name]" or name
  local display_name = filename == "" and name or filename

  local buffer_color = M.opts.buf_normal
  if vim.bo[buffer].readonly or
      not vim.bo[buffer].modifiable then
    buffer_color = M.opts.buf_ro
  elseif vim.bo[buffer].modified then
    buffer_color = M.opts.buf_mod
  end

  local filetype = vim.filetype.match { filename = filename }
  local icon, icon_hl = devicon.get_icon_by_filetype(filetype, { default = true })

  local display = ""
  display = display .. "%#" .. set_hl("StlBufferFileType" .. buffer, {
    fg = not M.opts.inv_buf_ft and hl(icon_hl).fg or M.opts.bg or "#101010",
    bg = not M.opts.inv_buf_ft and M.opts.bg or hl(icon_hl).fg,
  }) .. "# " .. icon .. " "
  display = display .. "%#" .. set_hl("StlBuffer" .. buffer, {
    fg = M.opts.inv_buf_name and M.opts.bg or buffer_color,
    bg = M.opts.inv_buf_name and buffer_color or M.opts.bg,
  }) .. "# "
  display = display .. "[" .. buffer .. "]" .. display_name .. " "
  return display
end

function M.Mode()
  local mode = vim.api.nvim_get_mode()
  local name, bg_color, fg_color = M.opts.mode(mode.mode)

  local display = ""
  display = display .. "%#" .. set_hl("StlMode", {
    fg = fg_color or M.opts.bg,
    bg = bg_color,
  }) .. "# " .. name .. " "
  return display
end

function M.Location()
  local linec = #vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pos = vim.api.nvim_win_get_cursor(0)
  local curl, ccol = pos[1], tostring(pos[2] + 1)
  local perc = math.floor(curl / linec * 100)
  while #ccol < 3 do
    ccol = " " .. ccol
  end

  local display = ""
  display = display .. "%#StlNormal# (%#" .. set_hl("StlLocCurLine", {
    fg = M.opts.cur_line,
    bg = M.opts.bg
  }) .. "#"
  display = display .. curl .. "%#StlNormal#/%#" .. set_hl("StlLocMaxLine", {
    fg = M.opts.max_line,
    bg = M.opts.bg
  })
  display = display .. "#" .. linec .. "%#StlNormal#):%#"
  display = display .. set_hl("StlLocCurCol", {
    fg = M.opts.cur_col,
    bg = M.opts.bg
  })
  display = display .. "#" .. ccol .. "%#StlNormal# %#"
  display = display .. set_hl("StlLocPercent", {
    fg = M.opts.inv_percent and M.opts.bg or M.opts.percent,
    bg = M.opts.inv_percent and M.opts.percent or M.opts.bg
  }) .. "# " .. perc .. "%% "
  return display
end

function M.Lsp()
  local display = ""
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    display = "%#" .. set_hl("StlLsp", {
      fg = M.opts.lsp,
      bg = M.opts.bg,
    }) .. "#@["
    for _, client in ipairs(clients) do
      display = display .. " " .. client.name .. "(" .. client.id .. ")"
    end
    display = display .. " ]"
  end
  return display
end

function M.Diag()
  local display = ""
  local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf())
  local counts = {}
  for _, diag in ipairs(diags) do
    counts[diag.severity] = (counts[diag.severity] or 0) + 1
  end
  local sev = vim.diagnostic.severity
  for i, diag in pairs(counts) do
    if i == sev.E then
      display = display .. "%#DiagnosticError# E" .. diag
    elseif i == sev.W then
      display = display .. "%#DiagnosticWarn# W" .. diag
    elseif i == sev.I then
      display = display .. "%#DiagnosticInfo# I" .. diag
    elseif i == sev.H then
      display = display .. "%#DiagnosticHint# H" .. diag
    end
  end
  if #diags > 0 then
    display = display .. " "
  end
  return display
end

function M.get()
  set_hl("StlNormal", { fg = M.opts.fg, bg = M.opts.bg })
  local display = "%#StlNormal#"
  display = display .. M.Mode()
  display = display .. M.BufStat()
  display = display .. M.Diag()
  display = display .. "%#StlNormal#%="
  display = display .. M.Lsp()
  display = display .. M.Location()
  return display
end

return M
