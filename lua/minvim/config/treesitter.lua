local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade"
}

local tsconf = require("nvim-treesitter.configs")
tsconf.setup {
  ensure_installed = { "markdown", "lua", "vim", "vimdoc" },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  modules = {},
  highlight = { enable = true },
  indent = { enable = true },
}
