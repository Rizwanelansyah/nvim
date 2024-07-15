require("gruvbox").setup({
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,
  contrast = "hard",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

---@param name string
---@return vim.api.keyset.hl_info
local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, create = false })
end

local on_colorscheme = function()
  local normal = hl("Normal")
  local color = require("gruvbox").palette
  local highlights = {
    NormalFloat = { bg = normal.bg, fg = normal.fg },
    FloatBorder = { bg = normal.bg, fg = normal.fg },
    ['@variable'] = { fg = color.light_aqua },
    FloatBorder1 = { bg = normal.bg, fg = color.light0 },
    FloatBorder2 = { bg = normal.bg, fg = color.light1 },
    FloatBorder3 = { bg = normal.bg, fg = color.light2 },
    FloatBorder4 = { bg = normal.bg, fg = color.light3 },
    FloatBorder5 = { bg = normal.bg, fg = color.light3 },
    FloatBorder6 = { bg = normal.bg, fg = color.light2 },
    FloatBorder7 = { bg = normal.bg, fg = color.light1 },
    FloatBorder8 = { bg = normal.bg, fg = color.light0 },
  }

  ---@diagnostic disable-next-line: redefined-local
  for hl, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl, val)
  end
end
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = on_colorscheme,
})
on_colorscheme()
