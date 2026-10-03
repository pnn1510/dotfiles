return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      line_breaks = true,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
  },

  -- 1. FORMATTER CONFIGURATION
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        -- Runs prettier first; if missing, falls back to markdownlint-cli2
        markdown = { "prettier", "markdownlint-cli2", stop_after_first = true },
      },
      formatters = {
        prettier = {
          -- Tell prettier to wrap prose to match markdownlint's 80 char limit
          args = { "--stdin-filepath", "$FILENAME", "--prose-wrap", "always" },
        },
      },
      -- Enable autoformatting on save:
    },
  },

  -- 2. LINTER CONFIGURATION (Fixes lint diagnostics)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      }

      -- Trigger linting on save and text insert leave
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
