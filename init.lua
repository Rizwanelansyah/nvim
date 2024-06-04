vim.api.nvim_set_var('t_Cs', '\\e[4:3m')
vim.api.nvim_set_var('t_Ce', '\\e[4:0m')
vim.o.guifont = "FiraCode Nerd Font:h12"

function LOG(x)
  vim.print(x)
  return x
end

vim.filetype.add {
  extension = {
    html = "html",
  }
}

require("rizwan")
