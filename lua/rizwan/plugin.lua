local function cfg(name)
  return function()
    require("rizwan.config." .. name)
  end
end

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = cfg("nvim_cmp"),
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      { "folke/neodev.nvim", opts = {} },
    },
    config = cfg("lsp"),
  },

  {
    "navarasu/onedark.nvim",
    config = cfg("onedark")
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = cfg("treesitter"),
  },

  {
    'rcarriga/nvim-notify',
    config = function()
      local n = require("notify")
      ---@diagnostic disable-next-line: missing-fields
      n.setup {
        background_colour = "#000000",
        fps = 10,
        time_formats = {
          notification = "%H:%M:%S",
          notification_history = "%H:%M:%S",
        },
      }
      vim.notify = n
    end
  },

  {
    -- "Rizwanelansyah/simplyfile.nvim",
    -- tag = "v0.6",
    dir = "/home/rizwan/Projects/nvim/simplyfile.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("simplyfile"),
  },
}
