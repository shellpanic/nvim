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

-- Snippets: quick controls (do not steal Tab)
do
   local ok, ls = pcall(require, "luasnip")
   if ok then
      -- Abort current snippet and keep text as-is
      vim.keymap.set({ "i", "s" }, "<C-]>", function()
         if ls.in_snippet() then
            ls.unlink_current()
         else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-]>", true, false, true), "n", true)
         end
      end, { silent = true, desc = "Snippet: Abort placeholders" })

      -- Optional: forward/backward jump within snippet placeholders
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
         if ls.jumpable(1) then ls.jump(1) end
      end, { silent = true, desc = "Snippet: Next placeholder" })
      -- Use Shift-Tab in snippet context via default mappings, or map your own
   end
end
