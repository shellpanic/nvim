-- DAP domain keymaps
-- no return; this module is for side-effect keymaps only

vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { silent = true, desc = "Toggle breakpoint" })
vim.keymap.set(
   "n",
   "<Leader>dB",
   ":DapSetConditionalBreakpoint<CR>",
   { silent = true, desc = "Conditional breakpoint" }
)
vim.keymap.set("n", "<Leader>dl", ":DapSetLogPoint<CR>", { silent = true, desc = "Set log point" })
vim.keymap.set("n", "<Leader>dx", ":DapClearBreakpoints<CR>", { silent = true, desc = "Clear breakpoints" })
vim.keymap.set("n", "<Leader>du", ":DapUiToggle<CR>", { silent = true, desc = "DAP UI toggle" })
vim.keymap.set("n", "<Leader>do", ":DapUiOpen<CR>", { silent = true, desc = "DAP UI open" })
vim.keymap.set("n", "<Leader>dc", ":DapUiClose<CR>", { silent = true, desc = "DAP UI close" })
vim.keymap.set("n", "<Leader>de", ":DapUiEval<CR>", { silent = true, desc = "DAP evaluate" })
vim.keymap.set("v", "<Leader>de", ":<C-U>'<,'>DapUiEval<CR>", { silent = true, desc = "DAP evaluate selection" })
vim.keymap.set("n", "<Leader>dr", ":DapReplToggle<CR>", { silent = true, desc = "DAP REPL toggle" })
vim.keymap.set("n", "<Leader>dR", ":DapRunLast<CR>", { silent = true, desc = "DAP run last" })
vim.keymap.set("n", "<F3>", ":DapTerminate<CR>", { silent = true, desc = "DAP terminate" })
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { silent = true, desc = "DAP continue" })
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { silent = true, desc = "DAP step over" })
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { silent = true, desc = "DAP step into" })
vim.keymap.set("n", "<F12>", ":DapStepOut<CR>", { silent = true, desc = "DAP step out" })
vim.keymap.set("n", "<Leader>dpr", ":DapPythonTestMethod<CR>", { silent = true, desc = "DAP Py test" })
