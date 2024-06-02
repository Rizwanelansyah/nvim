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

vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter','BufWritePost'}, {
  group = vim.api.nvim_create_augroup('Treesitter', {}),
  callback = function()
    vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})
