vim.o.termguicolors = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.number = true
vim.o.cursorline = true
vim.o.matchtime = 1
vim.o.showmatch = true
vim.o.wrap = false
vim.o.foldlevel = 10000
vim.o.foldmethod = 'expr'
vim.o.laststatus = 3
vim.o.scrolloff = 10
vim.cmd[[ set foldtext=v:lua.require'rizwan.config.utils'.foldtext() ]]
vim.cmd[[ set fillchars+=fold:\ " ]]

vim.g.mapleader = " "
vim.g.loaded_netrwPlugin = 0
vim.g.branch_name = ""

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'FocusGained' }, {
  callback = function()
    local git_root = vim.fs.root(0, { ".git" })
    if git_root then
      vim.g.branch_name = vim.fn.system("cd " .. git_root .. " && git branch --show-current 2> /dev/null | tr -d '\n'")
    else
      vim.g.branch_name = ""
    end
  end
})
