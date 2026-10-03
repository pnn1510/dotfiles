-- Go. The `lang.go` extra already provides: gopls (same gofumpt / codelenses /
-- hints / analyses / staticcheck settings you had), goimports + gofumpt, delve,
-- nvim-dap-go, gomodifytags, impl, treesitter parsers and neotest-golang.
-- Only what the extra does NOT give you lives here.
return {
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    ft = { "go", "gomod", "gowork", "gosum" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false, -- gopls is configured by LazyVim
      dap_debug = false, -- nvim-dap-go (from the extra) owns debugging
    },
    -- Moved from <leader>g* (collides with LazyVim's git keys: gs, gc, gi, gf)
    -- to <leader>cg* (code -> go). Test keys dropped: neotest (<leader>t*) covers them.
    keys = {
      { "<leader>cgj", "<cmd>GoTagAdd json<cr>", desc = "Add json struct tags", ft = "go" },
      { "<leader>cgy", "<cmd>GoTagAdd yaml<cr>", desc = "Add yaml struct tags", ft = "go" },
      { "<leader>cgr", "<cmd>GoTagRm<cr>", desc = "Remove struct tags", ft = "go" },
      { "<leader>cgf", "<cmd>GoFillStruct<cr>", desc = "Fill struct", ft = "go" },
      { "<leader>cge", "<cmd>GoIfErr<cr>", desc = "Insert if err != nil", ft = "go" },
      { "<leader>cgc", "<cmd>GoCoverage<cr>", desc = "Coverage overlay", ft = "go" },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>cg", group = "go" })
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-golang"] = { go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" } },
      },
    },
  },
}
