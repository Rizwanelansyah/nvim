V = {}

function os.capture(cmd)
  local p, err = io.popen(cmd, 'r')
  if not err then
    if p then
      local res = p:read("*a")
      p:close()
      return res
    end
  else
    print("Error: ", err)
  end
  return ""
end

function string:split(char)
  return vim.split(tostring(self), char)
end

function string:make_comp(map)
  local item = tostring(self)
  local comp = {
    word = item,
    label = item,
    insertText = item,
  }
  return map and map(comp) or comp
end

function V.capture(cmd)
  return vim.api.nvim_exec2(cmd, { output = true }).output
end

function V.hl_groups()
  local lines = V.capture("highlight"):split('\n')
  lines = vim.tbl_map(function (value)
    return value:match("^([^ ]+)")
  end, lines)
  return lines
end
