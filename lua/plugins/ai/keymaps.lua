-- AI domain keymaps
-- no return; this module is for side-effect keymaps only

-- Copilot Chat
vim.keymap.set("n", "<Leader>cc", ":CopilotChatToggle<CR>", { silent = true, desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<Leader>ccr", ":CopilotChatReset<CR>", { silent = true, desc = "Reset Copilot Chat" })
vim.keymap.set("v", "<Leader>ccs", ":CopilotChat<CR>", { silent = true, desc = "Copilot Chat with selection" })

-- Codex
vim.keymap.set("n", "<leader>ccc", ":CodexToggle<CR>", { silent = true, desc = "Toggle Codex popup" })
