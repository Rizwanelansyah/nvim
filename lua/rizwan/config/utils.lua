local M = {}

function M.foldtext()
  local from = vim.fn.getline(vim.v.foldstart)
  local to = vim.trim(vim.fn.getline(vim.v.foldend))
  return from .. " ... " .. to
end

return M
