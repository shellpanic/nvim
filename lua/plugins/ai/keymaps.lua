-- AI domain keymaps
-- no return; this module is for side-effect keymaps only

vim.keymap.set("n", "<leader>aa", ":Sidekick cli toggle<CR>", { silent = true, desc = "AI: Toggle active CLI" })
vim.keymap.set(
   "n",
   "<leader>ac",
   ":Sidekick cli toggle name=claude focus=true<CR>",
   { silent = true, desc = "AI: Toggle Claude" }
)
vim.keymap.set(
   "n",
   "<leader>ax",
   ":Sidekick cli toggle name=codex focus=true<CR>",
   { silent = true, desc = "AI: Toggle Codex" }
)
vim.keymap.set("n", "<leader>as", ":Sidekick cli select<CR>", { silent = true, desc = "AI: Select CLI" })
vim.keymap.set(
   { "n", "x" },
   "<leader>at",
   ':Sidekick cli send msg="{this}"<CR>',
   { silent = true, desc = "AI: Send current context" }
)
vim.keymap.set("n", "<leader>af", ':Sidekick cli send msg="{file}"<CR>', { silent = true, desc = "AI: Send file" })
vim.keymap.set(
   "x",
   "<leader>av",
   ':Sidekick cli send msg="{selection}"<CR>',
   { silent = true, desc = "AI: Send selection" }
)
vim.keymap.set({ "n", "x" }, "<leader>ap", ":Sidekick cli prompt<CR>", { silent = true, desc = "AI: Select prompt" })
vim.keymap.set("n", "<leader>ad", ":Sidekick cli close<CR>", { silent = true, desc = "AI: Close CLI session" })
