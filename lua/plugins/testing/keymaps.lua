-- Testing domain keymaps
-- no return; this module is for side-effect keymaps only

vim.keymap.set("n", "<Leader>iwf", ":NeotestWatchFileToggle<CR>", { silent = true, desc = "Toggle file watch" })
vim.keymap.set("n", "<Leader>is", ":NeotestSummaryToggle<CR>", { silent = true, desc = "Toggle test summary" })
vim.keymap.set("n", "<Leader>isn", ":NeotestRunStop<CR>", { silent = true, desc = "Stop tests" })
vim.keymap.set("n", "<Leader>iw", ":NeotestWatchToggle<CR>", { silent = true, desc = "Toggle watch" })
vim.keymap.set("n", "<Leader>ir", ":NeotestRun<CR>", { silent = true, desc = "Run tests" })
vim.keymap.set("n", "<Leader>io", ":NeotestOutputOpen<CR>", { silent = true, desc = "Open test output" })
vim.keymap.set("n", "<Leader>ios", ":NeotestOutputOpenShort<CR>", { silent = true, desc = "Open short output" })
vim.keymap.set("n", "<Leader>iop", ":NeotestOutputPanelToggle<CR>", { silent = true, desc = "Toggle output panel" })
vim.keymap.set("n", "<Leader>ioc", ":NeotestOutputPanelClear<CR>", { silent = true, desc = "Clear output panel" })
vim.keymap.set("n", "<Leader>irf", ":NeotestRunFile<CR>", { silent = true, desc = "Run file tests" })
vim.keymap.set("n", "<Leader>id", ":NeotestRunDap<CR>", { silent = true, desc = "Run with DAP" })
vim.keymap.set("n", "<Leader>idf", ":NeotestRunFileDap<CR>", { silent = true, desc = "Run file with DAP" })
vim.keymap.set("n", "<Leader>ia", ":NeotestAttach<CR>", { silent = true, desc = "Attach to test" })
