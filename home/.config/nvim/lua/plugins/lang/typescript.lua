-- TypeScript / React. Enabled via extras: lang.typescript (vtsls, js-debug-adapter),
-- linting.eslint, formatting.prettier, lang.tailwind, lang.json.
-- Those already contain your vtsls inlay-hint/import settings and the ESLint
-- workingDirectories + format-on-save wiring, so they are not repeated here.
-- Removed: nvim-dap-vscode-js (archived), none-ls eslint_d (builtin removed),
-- `Snacks.util.lsp.on` hack (also checked for "tsserver" instead of "vtsls").

-- class-name helpers whose string args should get Tailwind completion

return {

  -- The extra defines pwa-node / pwa-chrome adapters and Launch/Attach configs;
  -- add the Chrome (dev server) config on top.

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "marilari88/neotest-vitest" }, -- swap for "nvim-neotest/neotest-jest" if needed
    opts = { adapters = { ["neotest-vitest"] = {} } },
  },

  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
}
