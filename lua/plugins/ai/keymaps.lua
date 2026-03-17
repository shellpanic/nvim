-- AI domain keymaps
-- no return; this module is for side-effect keymaps only

-- Codex
vim.keymap.set("n", "<leader>ax", ":CodexToggle<CR>", { silent = true, desc = "AI: Toggle Codex popup" })
