-- Editor domain keymaps
-- Keep search clear here to reduce global keymaps noise
vim.keymap.set("n", "<Leader>s", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

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

-- ToggleTerm
vim.keymap.set("n", "<Leader>t", ":ToggleTerm direction=tab<CR>", { silent = true, desc = "Open terminal in tab" })
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
vim.keymap.set("n", "<Leader>tg", ":LazyGitToggle<CR>", { silent = true, desc = "Open lazygit tui" })
vim.keymap.set("n", "<Leader>td", ":LazyDockerToggle<CR>", { silent = true, desc = "Open lazydocker tui" })
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })

-- Conform format
vim.keymap.set("n", "<Leader>mp", ":ConformFormat<CR>", { silent = true, desc = "Format file" })
vim.keymap.set("v", "<Leader>mp", ":'<,'>ConformFormat<CR>", { silent = true, desc = "Format selection" })

-- Lint
vim.keymap.set("n", "<C-ll>", ":LintTry<CR>", { silent = true, desc = "Trigger linting" })
