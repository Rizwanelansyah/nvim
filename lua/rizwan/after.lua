local on_color_scheme = function()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  local colors = require("onedark.colors")
  vim.api.nvim_set_hl(0, "Title", { fg = normal.fg, bg = normal.bg, undercurl = true })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = normal.fg, bg = normal.bg })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#989898", bg = normal.bg })
  vim.api.nvim_set_hl(0, "LspDeprecated", { fg = colors.yellow, strikethrough = true })
  vim.api.nvim_set_hl(0, "CmpKindName", { fg = colors.purple, italic = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = on_color_scheme,
})

on_color_scheme()

require("rizwan.config.lsp")
vim.cmd [[ set statusline=%!v:lua.require'rizwan.config.statusline'.get() ]]
vim.cmd [[ set winbar=%!v:lua.require'rizwan.config.winbar'.get() ]]
