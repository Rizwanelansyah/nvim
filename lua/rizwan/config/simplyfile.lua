local mapping = require("simplyfile.mapping")
local simplyfile = require("simplyfile")
simplyfile.setup {
  border = {
    up = "single",
    left = "single",
    right = "single",
    main = "single",
  },
  default_keymaps = true,
  keymaps = {
    d = function(dir)
      vim.ui.select({ 'Yes', 'No' }, {
        prompt = "Trassh This Files",
      }, function(choice)
        if choice == "Yes" then
          vim.cmd("silent !trash " .. dir.absolute)
---@diagnostic disable-next-line: missing-fields
          mapping.refresh { absolute = "" }
        end
      end)
    end,
    ["<CR>"] = function(dir)
      if not dir then return end
      if not dir.is_folder then
        simplyfile.close()
        vim.cmd("e " .. dir.absolute)
      end
    end,
    ["<C-u>"] = mapping.under_cursor_as_cwd,
    ["<C-p>"] = mapping.current_path_as_cwd,
  },
  win_opt = {
    right = {
      wrap = false,
    },
  },
}

vim.keymap.set("n", "<leader>fe", simplyfile.open, { desc = "Open File Explorer" })
