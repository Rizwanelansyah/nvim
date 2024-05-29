---setup LSP
---@param name string
---@param ft string[]
---@param cmd string[]
---@param root_dir string[]
---@param override vim.lsp.Client?
local function setup(name, ft, cmd, root_dir, override)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function(ev)
      if not vim.fn.executable(cmd[1]) then return end
      local ro = vim.api.nvim_get_option_value("readonly", { buf = ev.buf })
      local mo = vim.api.nvim_get_option_value("modifiable", { buf = ev.buf })
      if ro or not mo then return end
      if vim.api.nvim_buf_get_name(ev.buf) == "" then return end
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do
        if client.name == name then
          if vim.lsp.buf_is_attached(0, client.id) then
            return
          end
          vim.lsp.buf_attach_client(0, client.id)
          return
        end
      end
      ---@type vim.lsp.ClientConfig
      local opt = {
        name = name,
        cmd = cmd,
        root_dir = vim.fs.root(ev.buf, root_dir),
      }
      if override then
        opt = vim.tbl_extend("force", opt, override)
      end
      vim.lsp.start(opt)
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      require("rizwan.config.lsp.on_attach")(ev.data.client_id, ev.buf)
    end,
  })
end

setup("lua_ls", { "lua" }, { "lua-language-server" }, { ".luarc.json", "lazy-lock.json" }, {
  on_init = function(client)
    if client.root_dir ~= vim.env.HOME .. "/.config/nvim" then return end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- library = { vim.env.VIMRUNTIME },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {},
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities {},
})

setup("intelephense", { "php" }, { "intelephense", "--stdio" }, { "composer.json" })
setup("html", { "html" }, { "vscode-html-language-server", "--stdio" }, {})
setup("emmet_ls", { "html" }, { "emmet-ls", "--stdio" }, {})
setup("cssls", { "css", "scss", "sass", "less" }, { "vscode-css-language-server", "--stdio" }, {})

vim.api.nvim_create_user_command("LspStop", function(args)
  if args.args == "" then
    for _, lsp in ipairs(vim.lsp.get_clients()) do
      vim.lsp.stop_client(lsp.id, true)
    end
    return
  end
  local num = tonumber(args.args)
  if num then
    vim.lsp.stop_client(num, true)
  else
    for _, lsp in ipairs(vim.lsp.get_clients()) do
      if lsp.name == args.args then
        vim.lsp.stop_client(lsp.id, true)
      end
    end
  end
end, { nargs = "?" })

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("e " .. vim.env.HOME .. "/.local/state/nvim/lsp.log")
  vim.api.nvim_buf_set_keymap(0, 'n', "<ESC>", "", {
    callback = function()
      vim.api.nvim_buf_delete(0, { force = true })
    end
  })
end, { nargs = 0 })
