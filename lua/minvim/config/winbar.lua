local M = {}
local stl = require("minvim.config.statusline")

---@param name string
---@param keyset vim.api.keyset.highlight
---@return string
local function set_hl(name, keyset)
  vim.api.nvim_set_hl(0, name, keyset)
  return name
end

function M.Diag()
  local display = ""
  local diags = vim.diagnostic.get()
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
    display = "%#Directory#[root]%#Normal#" .. display .. " "
  end
  return display
end

function M.get()
  local display = "%#".. set_hl("WinBarNormal", { bg = stl.opts.accent, fg = stl.opts.bg or "#101010" }) .."#"
  local buffers = vim.api.nvim_list_bufs()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(buffers) do
    if vim.fn.buflisted(buf) == 1 then
      if buf == current then
      display = display .. "%#" .. set_hl("WinBarSelected", { bg = stl.opts.bg, fg = stl.opts.accent }) .. "# " .. vim.fs.basename(vim.fn.bufname(buf)) .. " %#WinBarNormal#"
      else
      display = display .. " " .. vim.fs.basename(vim.fn.bufname(buf)) .. " "
      end
    end
  end
  display = display .. " %#Normal#%=" .. M.Diag()
  return display
end

return M
