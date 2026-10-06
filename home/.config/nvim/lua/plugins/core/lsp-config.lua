local class_regex = {}

local class_fns = { "cva", "cx", "clsx", "cn" }
for _, fn in ipairs(class_fns) do
  table.insert(class_regex, { fn .. "\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" })
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local ret = {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        inlay_hints = { enabled = true, exclude = { "vue" } },
        codelens = { enabled = false },
        folds = { enabled = true },
        format = { formatting_options = nil, timeout_ms = nil },
        -- stylua: ignore
        keys = {
          { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
          { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
          { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
          { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
          { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
          { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
          { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
          { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
          { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = { "n" }, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
          { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
          { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
          { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight", desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight", desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight", desc = "Next Reference", enabled = function() return Snacks.words.is_enabled() end },
          { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight", desc = "Prev Reference", enabled = function() return Snacks.words.is_enabled() end },
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
            has = "codeAction",
            enabled = function(buf)
              local code_actions = vim.tbl_filter(function(action)
                return action:find("^source%.organizeImports%.?$")
              end, LazyVim.lsp.code_actions({ bufnr = buf }))
              return #code_actions > 0
            end,
          },
        },
        servers = {
          ruff = {
            cmd_env = { RUFF_TRACE = "messages" },
            init_options = {
              settings = { logLevel = "error" },
            },
          },
          pyright = {},
          jdtls = {},
          ["*"] = {
            capabilities = {
              workspace = {
                fileOperations = { didRename = true, willRename = true },
              },
            },
          },
          stylua = { enabled = false },
          lua_ls = {
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                codeLens = { enable = true },
                completion = { callSnippet = "Replace" },
                doc = { privateName = { "^_" } },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        setup = {
          ruff = function()
            Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end)
          end,
          jdtls = function()
            return true -- avoid duplicate servers
          end,
        },
      }

      -- Enable Pyright and Ruff for Python buffers
      local python_servers = { "pyright", "ruff" }
      for _, server in ipairs(python_servers) do
        ret.servers[server] = ret.servers[server] or {}
        ret.servers[server].enabled = true
      end

      return ret
    end,
  },
}
