local plugins = {}

local function format(plugin)
  if type(plugin) == "table" then
    if type(plugin.config) == "string" then
      local name = plugin.config
      plugin.config = function()
        pcall(require, "minvim.config." .. name)
      end
    end
  end
  return plugin
end
local function add(plugin)
  table.insert(plugins, format(plugin))
end
local function lazyadd(plugin)
  if type(plugin) ~= 'table' then
    plugin = { plugin }
  end
  plugin.lazy = true
  add(plugin)
end

add {
  "vhyrro/luarocks.nvim",
  priority = 1001,
  opts = {
    rocks = { "magick" },
  },
}

add {
  "3rd/image.nvim",
  config = "image",
}

add {
  "Rizwanelansyah/simplyfile.nvim",
  tag = "v0.8",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = "simplyfile",
}

add {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = "treesitter",
}

add {
  "ellisonleao/gruvbox.nvim",
  -- config = "gruvbox",
}

add {
  'navarasu/onedark.nvim',
  config = "onedark",
}

add {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
  },
  config = "nvim_cmp",
}

add {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/nvim-cmp',
    "jwalton512/vim-blade",
  },
  config = "lsp",
}

add {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
}
lazyadd "Bilal2453/luvit-meta"
add {
  dir = vim.env.HOME .. "/Projects/nvim/windui.nvim",
  config = "windui",
}
add {
  'ricardoramirezr/blade-nav.nvim',
  ft = { 'blade', 'php' },
}

return plugins
