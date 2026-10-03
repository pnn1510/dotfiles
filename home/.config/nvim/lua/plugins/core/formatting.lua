-- Single source of truth for conform.nvim overrides.
-- Formatter binaries come from the LazyVim extras (see README / :LazyExtras):
--   lang.go -> goimports, gofumpt | lang.python -> ruff | formatting.prettier -> prettier
-- Function form is used on purpose: conform's per-filetype lists are *replaced*
-- (not merged) by lazy.nvim when given as a plain table, which is fragile.
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        -- Order matters: apply autofixes first, then format the result.
        python = { "ruff_fix", "ruff_format" },
        -- prettier if available, otherwise markdownlint-cli2 --fix
        markdown = { "prettier", "markdownlint-cli2", stop_after_first = true },
      })

      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        prettier = {
          -- Wrap markdown prose at 80 cols to match markdownlint; leave every
          -- other filetype handled by prettier untouched.
          prepend_args = function(_, ctx)
            if vim.bo[ctx.buf].filetype == "markdown" then
              return { "--prose-wrap", "always" }
            end
            return {}
          end,
        },
      })
    end,
  },
}
