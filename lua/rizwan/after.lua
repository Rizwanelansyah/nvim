local on_color_scheme = function()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu" })
  local pmenu_sel = vim.api.nvim_get_hl(0, { name = "PmenuSel" })
  local colors = require("onedark.colors")
  vim.api.nvim_set_hl(0, "Title", { fg = normal.fg, bg = normal.bg, undercurl = true })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = normal.fg, bg = normal.bg })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#989898", bg = normal.bg })
  vim.api.nvim_set_hl(0, "LspDeprecated", { fg = colors.yellow, strikethrough = true })
  vim.api.nvim_set_hl(0, "CmpKindName", { fg = colors.purple, italic = true })
  vim.api.nvim_set_hl(0, "LineNr", { bg = pmenu.bg, fg = pmenu.fg })
  vim.api.nvim_set_hl(0, "CursorLineNr", { reverse = true, italic = true })

  local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
  vim.api.nvim_set_hl(0, "Folded", { fg = comment.fg, bg = normal.bg, italic = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = on_color_scheme,
})

on_color_scheme()

require("rizwan.config.lsp")
vim.cmd [[ set statusline=%!v:lua.require'rizwan.config.statusline'.get() ]]
vim.cmd [[ set winbar=%!v:lua.require'rizwan.config.winbar'.get() ]]
vim.cmd [[ set statuscolumn=%!v:lua.require'rizwan.config.statuscol'.get() ]]

vim.keymap.set('n', '<leader>bb', ':buffer ')
vim.keymap.set('n', '<leader>bn', '<CMD>bnext<CR>')
vim.keymap.set('n', '<leader>bv', '<CMD>bprevious<CR>')
vim.keymap.set('n', '<leader>bs', ':bdelete ')
vim.keymap.set('n', '<leader>bd', '<CMD>bdelete<CR>')
vim.keymap.set('n', '<leader>bo', function()
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) and cur_buf ~= buf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end)

vim.keymap.set('n', '<C-Down>', '<CMD>m+1<CR>==')
vim.keymap.set('n', '<C-Up>', '<CMD>m-2<CR>==')

vim.keymap.set('v', '<C-Down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR>gv=gv")

vim.keymap.set('i', '<C-Up>', '<CMD>stopinsert<CR><CMD>m-2<CR>==a')
vim.keymap.set('i', '<C-Down>', '<CMD>stopinsert<CR><CMD>m+1<CR>==a')

vim.keymap.set('v', 's)', "<ESC>`>a)<ESC>`<i(<ESC>")
vim.keymap.set('v', 's(', "<ESC>`>a)<ESC>`<i(<ESC>")
vim.keymap.set('v', 's}', "<ESC>`>a}<ESC>`<i{<ESC>")
vim.keymap.set('v', 's{', "<ESC>`>a}<ESC>`<i{<ESC>")
vim.keymap.set('v', 's[', "<ESC>`>a]<ESC>`<i[<ESC>")
vim.keymap.set('v', 's]', "<ESC>`>a]<ESC>`<i[<ESC>")
vim.keymap.set('v', 's"', "<ESC>`>a\"<ESC>`<i\"<ESC>")
vim.keymap.set('v', 's\'', "<ESC>`>a'<ESC>`<i'<ESC>")
