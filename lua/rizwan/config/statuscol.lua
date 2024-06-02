local M = {}

function M.get()
  local txt = " "
  local not_folded = vim.fn.foldclosed(vim.v.lnum) == -1
  if vim.v.virtnum == 0 then
    txt = txt .. "%=" .. (not_folded and "" or "{") .. vim.v.lnum .. (not_folded and " " or "}")
  elseif vim.v.virtnum > 0 then
    txt = txt .. "%=~"
  else
    txt = txt .. "%="
  end
  return txt .. "%#Normal# "
end

return M
