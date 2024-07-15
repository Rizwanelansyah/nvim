require("minvim.config.cmp_sources.anycmp")
require("minvim.config.cmp_sources.mysnip")
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

local cmp = require('cmp')

vim.keymap.set({ 'n', 'i', 's' }, '<M-Right>', function()
  if vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  end
end)
vim.keymap.set({ 'n', 'i', 's' }, '<M-Left>', function()
  if vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  end
end)

local cmp_kinds = {
  Text = ' ',
  Method = '󰰑 ',
  Function = '󰡱 ',
  Constructor = '󱌢 ',
  Field = '󰨾 ',
  Variable = ' ',
  Class = '󰯳 ',
  Interface = '󰰅 ',
  Module = ' ',
  Property = '󰭸 ',
  Unit = ' ',
  Value = ' ',
  Enum = '󰭯 ',
  Keyword = ' ',
  Snippet = ' ',
  Color = ' ',
  File = ' ',
  Reference = ' ',
  Folder = ' ',
  EnumMember = '󱟱 ',
  Constant = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({ border = border }),
    documentation = cmp.config.window.bordered({ border = border }),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Down>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  formatting = {
    format = function(entry, vim_item)
      if entry:is_deprecated() then
        vim_item.abbr_hl_group = "@lsp.mod.deprecated"
      end

      -- vim_item.menu = ({
      --   nvim_lsp = "LSP::",
      --   lazydev = "Lazy:",
      --   buffer = "Buff:",
      --   path = "Path:",
      --   cmdline = "Cmd::",
      --   anycmp = "Any::",
      --   ["blade-nav"] = "Bld::",
      -- })[entry.source.name] or entry.source.name or ":?:"

      vim_item.kind = cmp_kinds[vim_item.kind] or "??"

      if entry.source.name == "mysnip" then
        vim_item.kind = cmp_kinds.Snippet
        vim_item.kind_hl_group = "CmpItemKindSnippet"
      end
      return vim_item
    end,
    fields = { 'kind', 'abbr' },
    expandable_indicator = true,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'anycmp' },
    { name = 'mysnip' },
    {
      name = "lazydev",
      group_index = 0,
    },
  }, {
    { name = 'buffer' },
  })
} --[[@as cmp.ConfigSchema ]])

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})
