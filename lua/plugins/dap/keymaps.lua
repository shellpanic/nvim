-- DAP domain keymaps
-- no return; this module is for side-effect keymaps only

vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { silent = true, desc = "Toggle breakpoint" })
vim.keymap.set("n", "<F3>", ":DapTerminate<CR>", { silent = true, desc = "DAP terminate" })
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { silent = true, desc = "DAP continue" })
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { silent = true, desc = "DAP step over" })
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { silent = true, desc = "DAP step into" })
vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", { silent = true, desc = "DAP step out" })
vim.keymap.set("n", "<Leader>dpr", ":DapPythonTestMethod<CR>", { silent = true, desc = "DAP Py test" })
