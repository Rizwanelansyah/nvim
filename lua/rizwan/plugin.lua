local function cfg(name)
  return function()
    require("rizwan.config." .. name)
  end
end

return {
  { 'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = cfg("nvim_cmp"),
  },

  { "navarasu/onedark.nvim",
    config = cfg("onedark")
  },

  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = cfg("treesitter"),
  },

  { "Rizwanelansyah/simplyfile.nvim", tag = "v0.4", -- dir = "/home/rizwan/Projects/nvim/simplyfile.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("simplyfile"),
  },
}
