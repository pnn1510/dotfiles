-- Single source of truth for nvim-lint + the linter binaries it needs.
-- LazyVim already wires nvim-lint to BufReadPost / BufWritePost / InsertLeave,
-- so no custom autocmds or `config` override (the old markdown.lua replaced
-- LazyVim's config and could break linting for other filetypes).
-- Python is intentionally absent: the ruff LSP already reports diagnostics,
-- and adding nvim-lint ruff as well produced duplicates.
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        go = { "golangcilint" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      -- manually install packages that do not exist in this list please
      ensure_installed = { "zls", "gopls", "ts_ls" },
    },
  },
}
