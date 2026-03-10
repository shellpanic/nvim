-- Avoid prefix overlap: make clear-search a subkey of the search group (phrase: s+c)
vim.keymap.set("n", "<Leader>sc", ":noh<CR>", { silent = true, desc = "Search: Clear highlight" })

-- Telescope
vim.keymap.set(
   "n",
   "<Leader>sf",
   ":Telescope find_files hidden=true no_ignore=true<CR>",
   { silent = true, desc = "Find files" }
)
vim.keymap.set("n", "<Leader>sg", ":Telescope live_grep<CR>", { silent = true, desc = "Live grep" })
vim.keymap.set(
   "n",
   "<Leader>sr",
   ":Telescope neoclip initial_mode=normal<CR>",
   { silent = true, desc = "Search clipboard history" }
)
vim.keymap.set(
   "n",
   "<Leader>sm",
   ":Telescope macroscope initial_mode=normal<CR>",
   { silent = true, desc = "Search macros" }
)

-- ToggleTerm (avoid parent/child overlap by using <leader>tt)
vim.keymap.set("n", "<Leader>tt", ":ToggleTerm direction=tab<CR>", { silent = true, desc = "Terminal: Open in tab" })
vim.keymap.set(
   "n",
   "<Leader>tb",
   ":ToggleTerm direction=horizontal<CR>",
   { silent = true, desc = "Open terminal at bottom" }
)
vim.keymap.set(
   "v",
   "<Leader>xv",
   ":ToggleTermSendVisualSelection<CR>",
   { silent = true, desc = "Send selection to terminal" }
)
vim.keymap.set("n", "<Leader>tg", ":LazyGitToggle<CR>", { silent = true, desc = "Terminal: Open lazygit tui" })
vim.keymap.set("n", "<Leader>td", ":LazyDockerToggle<CR>", { silent = true, desc = "Terminal: Open lazydocker tui" })
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })

-- Code: Format & Lint moved under <leader>c
vim.keymap.set("n", "<Leader>cf", ":ConformFormat<CR>", { silent = true, desc = "Code: Format file" })
vim.keymap.set("v", "<Leader>cs", ":'<,'>ConformFormat<CR>", { silent = true, desc = "Code: Format selection" })

-- Lint
vim.keymap.set("n", "<Leader>cl", ":LintTry<CR>", { silent = true, desc = "Code: Lint now" })
