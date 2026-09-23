-- Misc domain keymaps
-- no return; this module is for side-effect keymaps only

-- Smoji under Misc group
vim.keymap.set("n", "<leader>me", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })
vim.keymap.set("i", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })
vim.keymap.set("t", "<C-e>", ":Smoji<CR>", { silent = true, desc = "Misc: Emoji picker (Smoji)" })

-- Remote SSH workspaces
vim.keymap.set("n", "<leader>mrc", "<Cmd>RemoteSSHFSConnect<CR>", { silent = true, desc = "Remote: Connect" })
vim.keymap.set("n", "<leader>mrd", "<Cmd>RemoteSSHFSDisconnect<CR>", { silent = true, desc = "Remote: Disconnect" })
vim.keymap.set("n", "<leader>mre", "<Cmd>RemoteSSHFSEdit<CR>", { silent = true, desc = "Remote: Edit SSH config" })
vim.keymap.set("n", "<leader>mrr", "<Cmd>RemoteSSHFSReload<CR>", { silent = true, desc = "Remote: Reload hosts" })
vim.keymap.set("n", "<leader>mrf", "<Cmd>RemoteSSHFSFindFiles<CR>", { silent = true, desc = "Remote: Find files" })
vim.keymap.set("n", "<leader>mrg", "<Cmd>RemoteSSHFSLiveGrep<CR>", { silent = true, desc = "Remote: Live grep" })
