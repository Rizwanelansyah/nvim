local cmp = require('cmp')

local kind_icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  view = {
    ---@diagnostic disable-next-line: missing-fields
    entries = { "wildmenu" },
  },

  formatting = {
    format = function (entry, vim_item)
      local kind = vim_item.kind
      vim_item.kind = " " .. (kind_icons[kind] or "??") .. " "
      vim_item.kind_hl_group = "CmpItemKind" .. kind
      if entry:is_deprecated() then
        vim_item.abbr_hl_group = "CmpItemAbbrDeprecated"
      end

      vim_item.menu = "(" .. kind .. ")"
      vim_item.menu_hl_group = "CmpItemMenu"
      return vim_item
    end,
    fields = { 'kind', 'abbr', 'menu' },
    expandable_indicator = true,
  },

  window = {
    documentation = {
      winhighlight = "Normal:Pmenu",
    },
    completion = {
      side_padding = 0,
      winhighlight = "CursorLine:Cursor,Normal:Pmenu",
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<S-Up>'] = cmp.mapping.scroll_docs(-4),
    ['<S-Down>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local ls = require("luasnip")
vim.keymap.set({"i"}, "<C-z>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<M-Right>", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<M-Left>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  ---@diagnostic disable-next-line: missing-fields
  matching = { disallow_symbol_nonprefix_matching = false }
})
