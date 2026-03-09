-- Misc domain keymaps
-- no return; this module is for side-effect keymaps only

vim.keymap.set("n", "<leader><leader>e", ":Smoji<CR>", { silent = true, desc = "Git[e]moji" })
vim.keymap.set("i", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Git[e]moji" })
vim.keymap.set("t", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Git[e]moji" })
