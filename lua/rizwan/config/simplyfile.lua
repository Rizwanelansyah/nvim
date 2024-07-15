local mapping = require("simplyfile.mapping")
local simplyfile = require("simplyfile")
local util = require("simplyfile.util")
local image_path = vim.env.HOME .. "/.config/nvim/lua/rizwan/images"

simplyfile.setup {
  border = {
    up    = "single",
    left  = "single",
    right = "single",
    main  = "single",
  },
  default_keymaps = true,
  keymaps = {
    d = function(dir)
      vim.ui.select({ 'Yes', 'No' }, {
        prompt = "Trassh This Files",
      }, function(choice)
        if choice == "Yes" then
          vim.cmd("silent !trash " .. util.sanitize(dir.absolute))
          ---@diagnostic disable-next-line: missing-fields
          mapping.refresh { absolute = "" }
        end
      end)
    end,
    -- ["<CR>"] = function(dir)
    --   if not dir then return end
    --   if not dir.is_folder then
    --     simplyfile.close()
    --     vim.cmd("e " .. dir.absolute)
    --   end
    -- end,
    ["<C-u>"] = mapping.under_cursor_as_cwd,
    ["<C-p>"] = mapping.current_path_as_cwd,
  },
  win_opt = {
    up = {},
    left = {},
    right = {
      wrap = false,
    },
    main = {},
  },
  margin = {
    right = 10,
    left = 10,
    up = 3,
    down = 3,
  },
  preview = {
    image = false,
  },
  grid_mode = {
    enabled = false,
    -- get_icon = function(dir)
    --   local renderrable = { "%.png$", "%.jpe?g$", "%.avif$", "%.gif$", "%.webp$", "%.svg$", }
    --   if util.matches(dir.absolute, renderrable) then return dir.absolute end
    --   if dir.is_folder then
    --     return image_path .. "/simplyfile/folder.png"
    --   else
    --     return image_path .. "/simplyfile/file.png"
    --   end
    -- end
  },
}

vim.keymap.set("n", "<leader>fe", simplyfile.open, { desc = "Open File Explorer" })
