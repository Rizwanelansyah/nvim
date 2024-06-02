vim.cmd [[ let &t_Cs = "\e[4:3m" ]]
vim.cmd [[ let &t_Ce = "\e[4:0m" ]]
vim.o.guifont = "JetBrainsMono Nerd Font:h9"

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
