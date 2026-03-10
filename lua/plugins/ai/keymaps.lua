-- AI domain keymaps
-- no return; this module is for side-effect keymaps only

-- Copilot Chat (moved under <leader>a)
vim.keymap.set("n", "<Leader>ac", ":CopilotChatToggle<CR>", { silent = true, desc = "AI: Toggle Copilot Chat" })
vim.keymap.set("n", "<Leader>ar", ":CopilotChatReset<CR>", { silent = true, desc = "AI: Reset Copilot Chat" })
vim.keymap.set("v", "<Leader>as", ":CopilotChat<CR>", { silent = true, desc = "AI: Copilot Chat with selection" })

-- Codex
vim.keymap.set("n", "<leader>ax", ":CodexToggle<CR>", { silent = true, desc = "AI: Toggle Codex popup" })
