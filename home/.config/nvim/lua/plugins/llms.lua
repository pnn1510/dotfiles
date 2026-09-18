return {
  -- {
  --   "huggingface/llm.nvim",
  --
  --   opts = {
  --     backend = "ollama",
  --     model = "qwen2.5-coder:7b",
  --     url = "http://localhost:11434/api/generate",
  --     tokens_to_clear = { "<|endoftext|>" },
  --     fim = {
  --       enabled = true,
  --       prefix = "<fim_prefix>",
  --       middle = "<fim_middle>",
  --       suffix = "</fim_suffix>",
  --     },
  --     debounce = 50,
  --     accept_keymaps = "<Tab>",
  --     dissmiss_keymaps = "<S-Tab>",
  --     lsp = {
  --       bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/llm_nvim/bin",
  --       version = "0.5.2",
  --     },
  --     request_body = {
  --       parameters = {
  --         max_new_tokens = 100,
  --         temperature = 0.1,
  --         repeat_penalty = 1,
  --       },
  --     },
  --     context_window = 1024,
  --     enable_suggestion_on_startup = true,
  --     enable_suggestion_on_file = "*",
  --     disable_url_path_completion = false,
  --   },
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
            model = "qwen2.5-coder:7b",
          },
          inline = {
            adapter = "ollama",
          },
          cmd = {
            adapter = "ollama",
          },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "qwen2.5-coder:7b",
                },
              },
            })
          end,
        },
      })
    end,
  },
}
