-- TypeScript / React development for LazyVim
-- Drop into ~/.config/nvim/lua/plugins/typescript.lua
--
-- Provides: LSP (vtsls/ts_ls), ESLint, Prettier formatting,
-- Tailwind CSS intellisense, JSX/TSX treesitter, and JS debugging.

return {
  ------------------------------------------------------------------
  -- Treesitter: JS/TS/React grammars
  ------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "json",
        "jsonc",
        "css",
        "graphql",
      })
    end,
  },

  ------------------------------------------------------------------
  -- Mason: ensure the right tools get installed
  ------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "eslint-lsp",
        "prettier",
        "js-debug-adapter",
        "tailwindcss-language-server",
      })
    end,
  },

  ------------------------------------------------------------------
  -- LSP: vtsls (actively maintained tsserver wrapper, faster than
  -- the older ts_ls/tsserver setup) + tailwindcss + eslint
  ------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "yioneko/nvim-vtsls",
    },
    opts = {
      servers = {
        vtsls = {
          settings = {
            workingDirectories = { mode = "auto" },
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- catch cva()/clsx()/cn() style utility calls
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
      setup = {
        eslint = function()
          Snacks.util.lsp.on(function(buf, client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },

  ------------------------------------------------------------------
  -- Formatting: Prettier via conform, ESLint autofix on save
  ------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        graphql = { "prettier" },
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.code_actions.eslint_d)
    end,
  },

  ------------------------------------------------------------------
  -- Debugging: Node/Chrome debug adapter for JS/TS/React
  ------------------------------------------------------------------
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = "mfussenegger/nvim-dap",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("dap-vscode-js").setup({
        node_path = "node",
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        debugger_cmd = { "js-debug-adapter" },
        log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
        log_file_level = vim.log.levels.ERROR,
        log_console_level = vim.log.levels.ERROR,
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      for _, lang in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        require("dap").configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (dev server)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  ------------------------------------------------------------------
  -- Testing: Jest/Vitest via neotest
  ------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "marilari88/neotest-vitest",
      -- "nvim-neotest/neotest-jest", -- swap in if your repo uses Jest
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
  },

  ------------------------------------------------------------------
  -- Nice-to-have: auto-close/rename JSX tags
  ------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
