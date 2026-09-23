-- Avoid prefix overlap: make clear-search a subkey of the search group (phrase: s+c)
vim.keymap.set("n", "<Leader>sc", ":noh<CR>", { silent = true, desc = "Search: Clear highlight" })

-- Neovim's built-in comment operator
vim.keymap.set("n", "<Leader>/", "gcc", { remap = true, silent = true, desc = "Comment: Toggle line" })
vim.keymap.set("x", "<Leader>/", "gc", { remap = true, silent = true, desc = "Comment: Toggle selection" })

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
-- An explicit count selects a terminal; it must never toggle an already visible
-- terminal closed. Capture the count before loading the plugin, then use the
-- terminal API directly so `2<Leader>tt` always shows/focuses terminal 2.
local function toggle_term(direction)
   return function()
      local count = vim.v.count
      local toggleterm = require("toggleterm")

      if count == 0 then
         toggleterm.toggle(nil, nil, nil, direction)
         return
      end

      local term = require("toggleterm.terminal").get_or_create_term(count, nil, direction)
      if term:is_open() then
         vim.api.nvim_set_current_win(term.window)
      else
         term:open(nil, direction)
      end
   end
end

vim.keymap.set("n", "<Leader>tt", toggle_term("tab"), { silent = true, desc = "Terminal: Open in tab" })
vim.keymap.set("n", "<Leader>tb", toggle_term("horizontal"), { silent = true, desc = "Open terminal at bottom" })
vim.keymap.set(
   "v",
   "<Leader>xv",
   ":ToggleTermSendVisualSelection<CR>",
   { silent = true, desc = "Send selection to terminal" }
)
vim.keymap.set("n", "<Leader>tg", ":LazyGitToggle<CR>", { silent = true, desc = "Terminal: Open lazygit tui" })
vim.keymap.set("n", "<Leader>td", ":LazyDockerToggle<CR>", { silent = true, desc = "Terminal: Open lazydocker tui" })
-- Terminal escape layer
-- In terminal mode Neovim forwards every key to the running program, so full-screen
-- TUIs (claude, codex, lazygit, ...) swallow `-` and no leader mapping is reachable.
-- Only mappings defined for mode "t" reach Neovim: keep them on Alt chords, which
-- those TUIs leave alone, and route each one back into the normal-mode bindings.
local function term_map(lhs, rhs, desc, opts)
   opts = vim.tbl_extend("force", { silent = true, desc = "Terminal: " .. desc }, opts or {})
   vim.keymap.set("t", lhs, rhs, opts)
end

local to_normal = "<C-\\><C-n>"

term_map("<C-t>", to_normal, "Enter Neovim normal mode")
term_map("<A-t>", to_normal, "Enter Neovim normal mode")
-- Alt + the leader key opens the leader popup without leaving the terminal window first
term_map(
   "<A-" .. vim.g.mapleader .. ">",
   to_normal .. vim.g.mapleader,
   "Start a leader mapping",
   { remap = true } -- the trailing leader key must hit the normal-mode mappings
)
term_map("<A-w>", to_normal .. "<C-w>", "Window command prefix")

-- Mirror the normal-mode window/tab motions one Alt press away
for key, motion in pairs({ Left = "h", Down = "j", Up = "k", Right = "l" }) do
   term_map("<A-" .. key .. ">", to_normal .. "<C-w>" .. motion, "Move to the " .. key:lower() .. " window")
end
term_map("<A-J>", to_normal .. ":tabprevious<CR>", "Switch to the previous tab")
term_map("<A-K>", to_normal .. ":tabnext<CR>", "Switch to the next tab")

-- Git review
vim.keymap.set("n", "<Leader>go", ":DiffviewOpen<CR>", { silent = true, desc = "Git: Open repository diff" })
vim.keymap.set("n", "<Leader>gc", ":DiffviewClose<CR>", { silent = true, desc = "Git: Close diff view" })
vim.keymap.set("n", "<Leader>gh", ":DiffviewFileHistory %<CR>", { silent = true, desc = "Git: File history" })

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
         if ls.jumpable(1) then
            ls.jump(1)
         end
      end, { silent = true, desc = "Snippet: Next placeholder" })
      -- Use Shift-Tab in snippet context via default mappings, or map your own
   end
end
