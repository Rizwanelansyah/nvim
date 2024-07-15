local option = {
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  number = true,
  relativenumber = false,
  cursorline = true,
  showmatch = true,
  matchtime = 1,
  wrap = false,
  scrolloff = 10,
  guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor",
}


for key, val in pairs(option) do
  vim.opt[key] = val
end

vim.filetype.add({
  extension = {
    ['blade.php'] = 'blade',
  },
})
