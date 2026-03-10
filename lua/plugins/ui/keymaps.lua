-- UI domain keymaps
-- no return; this module is for side-effect keymaps only

-- Neo-tree
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true, desc = "Neo-tree: Toggle" })
-- Move explorer under Editor group
vim.keymap.set("n", "<Leader>ee", ":Neotree toggle<CR>", { silent = true, desc = "Editor: Explorer toggle" })
vim.keymap.set("n", "<Leader>ef", ":Neotree focus<CR>", { silent = true, desc = "Editor: Explorer focus" })
vim.keymap.set(
   "n",
   "<Leader>eb",
   ":Neotree buffers float toggle reveal dir=./ selector<CR>",
   { silent = true, desc = "Editor: Explorer buffers" }
)

-- Color picker moved under Misc group
vim.keymap.set("n", "<Leader>mc", ":PickColor<CR>", { silent = true, desc = "Misc: Color picker" })

-- Outline moved under Code group
vim.keymap.set("n", "<Leader>co", ":AerialToggle<CR>", { silent = true, desc = "Code: Outline toggle" })

-- Which-key helpers
vim.keymap.set("n", "<leader>?", ":WhichKeyBuffer<CR>", { silent = true, desc = "Buffer Local Keymaps (which-key)" })
