-- UI domain keymaps
-- no return; this module is for side-effect keymaps only

-- Neo-tree
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neo-Tree" })
vim.keymap.set("n", "<Leader>n", ":Neotree focus<CR>", { silent = true, desc = "Focus Neo-Tree" })
vim.keymap.set(
   "n",
   "<Leader><Tab>",
   ":Neotree buffers float toggle reveal dir=./ selector<CR>",
   { silent = true, desc = "Toggle Neo-Tree buffers" }
)

-- Color picker
vim.keymap.set("n", "<Leader>c", ":PickColor<CR>", { silent = true, desc = "Pick a color" })

-- Aerial outline
vim.keymap.set("n", "<Leader>o", ":AerialToggle<CR>", { silent = true, desc = "Toggle outline" })

-- Which-key helpers
vim.keymap.set("n", "<leader>?", ":WhichKeyBuffer<CR>", { silent = true, desc = "Buffer Local Keymaps (which-key)" })
