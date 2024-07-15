local border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = border,
  }
)


vim.diagnostic.config {
  float = { border = border },
}

local lsp = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local servers = {
  lua_ls = {},
  rust_analyzer = {},
  cssls = {},
  tsserver = {},
  html = {},
  emmet_ls = {},
  jsonls = {},
  intelephense = {},
  ccls = {},
  taplo = {},
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
}

for server, opt in pairs(servers) do
  lsp[server].setup(vim.tbl_extend("force", {
    capabilities = capabilities,
    on_attach = require("rizwan.config.lsp.on_attach"),
  }, type(opt) == "function" and opt() or opt))
end
