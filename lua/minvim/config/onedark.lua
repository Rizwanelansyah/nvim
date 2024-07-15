ONEDARK_STYLE = "cool"
require('onedark').setup {
  -- Main options --
  style = ONEDARK_STYLE,                  -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = true,            -- Show/hide background
  term_colors = true,             -- Change terminal color as per the selected theme style
  ending_tildes = false,          -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false,   -- reverse item kind highlights in cmp menu

  -- toggle theme style ---
  toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },

  -- Custom Highlights --
  colors = {},       -- Override default colors
  highlights = {},   -- Override highlight groups

  -- Plugins Config --
  diagnostics = {
    darker = true,         -- darker colors for diagnostic
    undercurl = true,      -- use undercurl instead of underline for diagnostics
    background = true,     -- use background color for virtual text
  },
}

require("onedark").load()

---@param name string
---@return vim.api.keyset.hl_info
local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, create = false })
end

local on_colorscheme = function()
  local normal = hl("Normal")
  local color = require("onedark.palette")[ONEDARK_STYLE]
  local highlights = {
    NormalFloat = { bg = normal.bg, fg = normal.fg },
    FloatBorder = { bg = normal.bg, fg = normal.fg },
    Cursor = { bg = normal.fg, fg = normal.bg },
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
