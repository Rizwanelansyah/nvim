local M = {}

M.lua = {
  mod = "local M = {}\n\n$0\n\nreturn M",
  log = "print(\"Debug: \", ${1:foo})$0",
}

M.javascript = {
  log = "console.log(\"Debug: \", ${1:foo})$0",
}
M.typescript = vim.tbl_extend("force", M.javascript, {})

M.html = {
  ["in"] = "<label for=\"$1\">\n\t<input id=\"$1\" name=\"$2\" type=\"${3:text}\">$0\n</label>"
}
M.php = vim.tbl_extend('force', M.html, {
  dd = "var_dump(${1:$value});\ndie;$0",
  php = "<?php\n\t$0\n?>",
})
M.blade = M.php

M.go = {
  ie = "if err != nil {\n\t$0\n}",
  main = "func main() {\n\t$0\n}",
}

M.rust = {
  ils = "if let Some(${2:name}) = ${1:from} {\n\t$0\n}",
  main = "fn main() {\n\t$0\n}",
}

return M
