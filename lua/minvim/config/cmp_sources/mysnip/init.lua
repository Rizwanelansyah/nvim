---@type cmp.Source
local source = {}

function source.new()
  local self = {}
  self.items = {}
  self.snippets = require("minvim.config.cmp_sources.mysnip.snippets")
  return setmetatable(self, { __index = source })
end

---@param callback function
function source:complete(_, callback)
  self.items = {}
  local function add(name, insert)
    local item = {
      word = name,
      label = "[mysnip] " .. name,
      insertText = insert:sub(1, 1),
      data = insert:sub(2),
      get_documentation = function()
        return insert:split('\n')
      end
    }
    table.insert(self.items, item)
  end

  local ft = vim.bo.filetype
  for trig, ins in pairs(self.snippets[ft] or {}) do
    add(trig, ins)
  end

  callback(self.items)
end

function source:execute(item, callback)
  callback()
  vim.snippet.expand(item.data)
end

local cmp = require("cmp")
cmp.register_source("mysnip", source.new())
