-- Python development for LazyVim
-- Drop into ~/.config/nvim/lua/plugins/python.lua
--
-- Provides: LSP (pyright + ruff), formatting (ruff/black+isort), linting,
-- debugging (debugpy), and virtual-env awareness.

return {
  ------------------------------------------------------------------
  -- Treesitter: make sure python grammar is installed
  ------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "toml",
        "ninja",
        "rst",
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
        "pyright",
        "ruff",
        "debugpy",
      })
    end,
  },

  ------------------------------------------------------------------
  -- LSP: pyright for types/intellisense, ruff for lint/quickfixes
  ------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- "off" | "basic" | "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        -- ruff acts as an LSP for linting/code actions; disable its hover
        -- so pyright remains the source of hover/definitions.
        ruff = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports (Ruff)",
            },
          },
        },
      },
      setup = {
        ruff = function(_, opts)
          -- disable ruff hover in favor of pyright
          require("lspconfig").ruff.setup({
            on_attach = function(client)
              client.server_capabilities.hoverProvider = false
            end,
          })
          return true
        end,
      },
    },
  },

  ------------------------------------------------------------------
  -- Formatting: ruff format (fast, Black-compatible). Swap for
  -- black/isort below if you prefer the classic toolchain.
  ------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix" },
        -- python = { "isort", "black" }, -- alternative classic stack
      },
    },
  },

  ------------------------------------------------------------------
  -- Linting (optional extra layer via nvim-lint; ruff LSP already
  -- covers most of this, kept here for flake8/mypy style workflows)
  ------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },

  ------------------------------------------------------------------
  -- Debugging: debugpy via nvim-dap
  ------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap-python",
    dependencies = "mfussenegger/nvim-dap",
    ft = "python",
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },

  ------------------------------------------------------------------
  -- Virtual environment picker (detects venv/poetry/conda envs)
  ------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    ft = "python",
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true,
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  ------------------------------------------------------------------
  -- Testing: pytest integration via neotest
  ------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          dap = { justMyCode = false },
        },
      },
    },
  },
}
