-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, desc = "Move cursor right" })
vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true, desc = "Move cursor left" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Start of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-d>", "<Del>", { desc = "Delete forward" })
