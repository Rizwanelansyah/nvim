local border = {
  { "┌",  "FloatBorder1" },
  { "─",  "FloatBorder2" },
  { "┐", "FloatBorder3" },
  { "│",  "FloatBorder4" },
  { "┘",  "FloatBorder5" },
  { "─",  "FloatBorder6" },
  { "└", "FloatBorder7" },
  { "│",  "FloatBorder8" },
}

---@param client vim.lsp.Client
---@param bufnr integer
local function attach(client, bufnr)
  local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
    })
  end
  map('n', 'K', vim.lsp.buf.hover)
  map({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help)
  map('n', ']d', function() vim.diagnostic.goto_next { float = { border = border } } end)
  map('n', '[d', function() vim.diagnostic.goto_prev { float = { border = border } } end)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', '<leader>lf', vim.lsp.buf.format)
  map('n', '<leader>le', vim.diagnostic.show)
  map('n', '<leader>ca', vim.lsp.buf.code_action)
  map('n', '<leader>rn', vim.lsp.buf.rename)
end

vim.diagnostic.config {
  float = true,
  signs = false,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border
})

local lsp = require("lspconfig")
local configs = require('lspconfig.configs')

configs.blade = {
  default_config = {
    cmd = { "laravel-dev-generators", "lsp" },
    filetypes = { 'blade' },
    root_dir = function(fname)
      return lsp.util.find_git_ancestor(fname)
    end,
    settings = {},
  },
}

---@type table<string, lspconfig.Config|fun(opt: lspconfig.Config): lspconfig.Config>
local servers = {
  lua_ls = {},
  cssls = {},
  jsonls = {},
  emmet_ls = function(opt)
    opt.filetypes = { "css", "eruby", "html", "less", "sass", "scss", "svelte", "pug",
      "typescriptreact", "vue", "blade" }
    opt.capabilities.textDocument.completion.completionItem.snippetSupport = true
    return opt
  end,
  html = {
    filetypes = { "html", "blade", "templ" },
  },
  rust_analyzer = {},
  -- tsserver = {},
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
  tailwindcss = {},
  intelephense = {
    filetypes = { "php", "blade" },
    settings = {
      intelephense = {
        filetypes = { "php", "blade" },
        files = {
          associations = { "*.php", "*.blade.php" },
          maxSize = 5000000,
        },
      },
    },
  },
  zls = {},
}

local caps = require('cmp_nvim_lsp').default_capabilities()
for server, opt in pairs(servers) do
  local default = {
    capabilities = caps,
    on_attach = attach,
  }
  if type(opt) == "table" then
    opt = vim.tbl_extend('force', default, opt)
  elseif type(opt) == "function" then
    opt = opt(default) or default
  end
  lsp[server].setup(opt)
end
