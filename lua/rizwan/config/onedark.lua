require('onedark').setup {
  style = 'dark',      -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = false,
  cmp_itemkind_reverse = true,
  ending_tildes = false,
  code_style = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none'
  },
  colors = {},
  highlights = {},
}

require('onedark').load()
