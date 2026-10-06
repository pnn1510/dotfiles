-- Python. The `lang.python` extra already provides: pyright + ruff LSP (ruff hover
-- disabled, <leader>co organize imports), debugpy / nvim-dap-python,
-- venv-selector (<leader>cv) and treesitter parsers.
-- Removed as redundant/broken: manual ruff lspconfig.setup (deprecated API, it also
-- bypassed LazyVim's setup), mason `get_install_path()` (removed in Mason v2),
-- nvim-lint ruff (duplicate diagnostics), venv-selector opts (old schema).
return {

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-python"] = { runner = "pytest", dap = { justMyCode = false } },
      },
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        override_notify = false,
      },
    },
    --  Call config for Python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },
}
