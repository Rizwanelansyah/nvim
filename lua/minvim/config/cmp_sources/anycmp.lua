local source = {}

function source.new()
  local self = {}
  self.items = {}

  local function add(name)
    local i = tostring(name)
    local item = {
      word = i,
      label = i,
      insertText = i,
    }
    table.insert(self.items, item)
  end

  vim.keymap.set('i', '<C-c>', function()
    vim.ui.input({
      prompt = ":lua= ",
    }, function(input)
      if not input then return end
      if vim.trim(input) ~= "" then
        self.items = {}
        local final_expr
        for _, expr in ipairs(input:split('\\|')) do
          if not final_expr then
            final_expr = expr
          else
            final_expr = expr:gsub("\\@", final_expr)
          end
        end
        local prog = loadstring("return " .. final_expr)
        if not prog then return end
        local results = prog()
        if type(results) ~= "table" then
          add(results)
          return
        end

        for _, value in ipairs(results) do
          if type(value) ~= "table" then
            add(value)
          else
            table.insert(self.items, value)
          end
        end
      end
    end)
  end)
  return setmetatable(self, { __index = source })
end

---@param self cmp.Source
---@param callback function
function source.complete(self, _, callback)
  callback(self.items)
end

local cmp = require("cmp")
cmp.register_source("anycmp", source.new())
