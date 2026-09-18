-- Go development for LazyVim
-- Drop into ~/.config/nvim/lua/plugins/golang.lua
--
-- Provides: LSP (gopls), formatting/imports (gofumpt + goimports),
-- linting (golangci-lint), debugging (delve), struct tags, and
-- test/coverage tooling via go.nvim.

return {
  ------------------------------------------------------------------
  -- Treesitter: Go grammar + related file types
  ------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
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
        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "delve",
      })
    end,
  },

  ------------------------------------------------------------------
  -- LSP: gopls with sane defaults for a modern Go workflow
  ------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },

  ------------------------------------------------------------------
  -- Formatting: gofumpt (stricter gofmt) + goimports (fixes imports)
  ------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },

  ------------------------------------------------------------------
  -- Linting: golangci-lint via nvim-lint
  ------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },

  ------------------------------------------------------------------
  -- Debugging: delve via nvim-dap-go
  ------------------------------------------------------------------
  {
    "leoluz/nvim-dap-go",
    dependencies = "mfussenegger/nvim-dap",
    ft = "go",
    opts = {
      delve = {
        detached = vim.fn.has("win32") == 0,
      },
    },
  },

  ------------------------------------------------------------------
  -- go.nvim: struct tags, test generation, coverage overlay,
  -- run/build shortcuts, and :GoAddTag / :GoFillStruct helpers
  ------------------------------------------------------------------
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gosum" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false, -- nvim-lspconfig block above already configures gopls
      lsp_gofumpt = true,
      luasnip = true,
    },
    keys = {
      { "<leader>gsj", "<cmd>GoTagAdd json<cr>", desc = "Add json struct tags", ft = "go" },
      { "<leader>gsy", "<cmd>GoTagAdd yaml<cr>", desc = "Add yaml struct tags", ft = "go" },
      { "<leader>gsr", "<cmd>GoTagRm<cr>", desc = "Remove struct tags", ft = "go" },
      { "<leader>gtf", "<cmd>GoTestFunc<cr>", desc = "Test function", ft = "go" },
      { "<leader>gtF", "<cmd>GoTestFile<cr>", desc = "Test file", ft = "go" },
      { "<leader>gcv", "<cmd>GoCoverage<cr>", desc = "Coverage overlay", ft = "go" },
      { "<leader>gie", "<cmd>GoIfErr<cr>", desc = "Insert if err != nil", ft = "go" },
      { "<leader>gfs", "<cmd>GoFillStruct<cr>", desc = "Fill struct", ft = "go" },
    },
  },

  ------------------------------------------------------------------
  -- Testing: neotest with go-test adapter (uses gotestsum if present)
  ------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          args = { "-count=1", "-timeout=60s" },
        },
      },
    },
  },
}
