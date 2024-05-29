local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = {},
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  modules = {},
  auto_install = true,
  ignore_install = {},
})

vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('Treesitter', {}),
  callback = function()
    local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    vim.api.nvim_set_hl(0, "Folded", { fg = comment.fg, bg = normal.bg, italic = true })
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.foldlevel = 1000
    vim.cmd[[ set foldtext=v:lua.require'rizwan.config.utils'.foldtext() ]]
    vim.cmd("set formatoptions-=cro")
    vim.cmd("set fillchars+=fold:\\ ")
  end
})
