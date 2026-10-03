-- AI tooling. Endpoints/models live in one table so a version bump is a
-- one-line change.
local ollama = { name = "ollama", model = "qwen2.5-coder:7b" }

return {
  -- Inline completion (replaces the old `config = function() setup({}) end`)
  { "supermaven-inc/supermaven-nvim", event = "InsertEnter", opts = {} },

  -- Chat / inline / cmd against a local Ollama server (default http://localhost:11434,
  -- or $OLLAMA_HOST). Uses the current CodeCompanion schema: `interactions`
  -- (formerly `strategies`) and `adapter = { name, model }`.
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    },
    opts = {
      interactions = {
        chat = { adapter = ollama },
        inline = { adapter = ollama },
        cmd = { adapter = ollama },
      },
    },
  },
}
