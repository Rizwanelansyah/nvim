local s = require("simplyfile")
local m = require("simplyfile.mapping")
s.setup({
  open_on_enter = true,
  border = {
    up = "rounded",
    main = "rounded",
  },
  margin = {
    left = 1,
    right = 1,
  },
  keymaps = {
    d = function(dir)
      vim.ui.select({ "Yes", "No" }, {
        prompt = "Delete " .. dir.name .. "?",
      }, function(item)
        if item == "Yes" then
          vim.cmd("silent !trash " .. dir.absolute)
          ---@diagnostic disable-next-line: missing-fields
          m.refresh { absolute = "" }
        end
      end)
    end,
    ['<CR>'] = m.open,
  },
  preview = {
    image = true,
  },
} --[[@as SimplyFile.Opts ]])
vim.keymap.set('n', '<leader>fe', s.open)
