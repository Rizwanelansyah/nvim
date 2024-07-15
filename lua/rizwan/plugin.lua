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
      "foke/lazydev.nvim",
    },
    config = cfg("nvim_cmp"),
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true },
    },
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
      enabled = function(root_dir)
        return (vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled) and
            (root_dir:match("^" .. vim.env.HOME .. "/Projects/nvim/.*") or root_dir == vim.env.HOME .. "/.dotfiles/.config/nvim")
      end
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
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
    dir = "/home/rizwan/Projects/nvim/windui.nvim",
  },

  {
    "Rizwanelansyah/simplyfile.nvim",
    tag = "v0.8",
    -- dir = "/home/rizwan/Projects/nvim/simplyfile.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("simplyfile"),
  },

  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1001,
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },
  -- {
  --   "3rd/image.nvim",
  --   dependencies = { "luarocks.nvim" },
  --   config = cfg("image"),
  -- },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
