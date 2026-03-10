-- Misc domain keymaps
-- no return; this module is for side-effect keymaps only

-- Smoji under Misc group
vim.keymap.set("n", "<leader>me", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })
vim.keymap.set("i", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })
vim.keymap.set("t", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })
