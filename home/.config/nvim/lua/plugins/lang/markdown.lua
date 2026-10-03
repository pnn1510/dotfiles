-- Markdown. The `lang.markdown` extra provides render-markdown, markdown-preview,
-- prettier/markdownlint-cli2 installs and treesitter parsers. Formatter and linter
-- policy lives in core/formatting.lua and core/linting.lua.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- Carried over from your config. If `:checkhealth render-markdown` reports
    -- this key as unknown for your plugin version, delete it.
    opts = { line_breaks = true },
  },
}
