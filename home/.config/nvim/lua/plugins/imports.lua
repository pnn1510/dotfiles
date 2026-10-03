-- lazy.nvim only auto-loads lua/plugins/*.lua (not subfolders), so the two
-- subfolders are pulled in explicitly. Order doesn't matter: specs for the same
-- plugin are merged by lazy.nvim.
--   core/  cross-language infrastructure (theme, formatting, linting, AI)
--   lang/  one file per language: only what that language needs
return {
  { import = "plugins.core" },
  { import = "plugins.lang" },
}
