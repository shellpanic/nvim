-- Testing domain keymaps (under <leader>u for "unit")
-- no return; this module is for side-effect keymaps only

-- Run
vim.keymap.set("n", "<Leader>un", ":NeotestRun<CR>", { silent = true, desc = "Tests: Run nearest" })
vim.keymap.set("n", "<Leader>uf", ":NeotestRunFile<CR>", { silent = true, desc = "Tests: Run file" })

-- Watch
vim.keymap.set("n", "<Leader>uw", ":NeotestWatchToggle<CR>", { silent = true, desc = "Tests: Watch toggle" })
vim.keymap.set("n", "<Leader>uW", ":NeotestWatchFileToggle<CR>", { silent = true, desc = "Tests: Watch file toggle" })

-- Summary
vim.keymap.set("n", "<Leader>us", ":NeotestSummaryToggle<CR>", { silent = true, desc = "Tests: Summary toggle" })
-- Avoid parent/child overlap with <leader>us*: use capital S for Stop
vim.keymap.set("n", "<Leader>uS", ":NeotestRunStop<CR>", { silent = true, desc = "Tests: Stop" })

-- Output
vim.keymap.set("n", "<Leader>uo", ":NeotestOutputOpen<CR>", { silent = true, desc = "Tests: Output open" })
vim.keymap.set("n", "<Leader>uO", ":NeotestOutputOpenShort<CR>", { silent = true, desc = "Tests: Output short" })
vim.keymap.set("n", "<Leader>up", ":NeotestOutputPanelToggle<CR>", { silent = true, desc = "Tests: Output panel" })
vim.keymap.set("n", "<Leader>uc", ":NeotestOutputPanelClear<CR>", { silent = true, desc = "Tests: Output clear" })

-- Debug
vim.keymap.set("n", "<Leader>ud", ":NeotestRunDap<CR>", { silent = true, desc = "Tests: Debug nearest" })
vim.keymap.set("n", "<Leader>uD", ":NeotestRunFileDap<CR>", { silent = true, desc = "Tests: Debug file" })

-- Attach
vim.keymap.set("n", "<Leader>ua", ":NeotestAttach<CR>", { silent = true, desc = "Tests: Attach" })
