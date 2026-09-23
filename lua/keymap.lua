local default_options = { noremap = true, silent = true, nowait = false }
local function set_keymap(mode, shortcut, action, description, opts)
   opts = vim.tbl_extend("force", default_options, opts or {}, { desc = description })
   vim.keymap.set(mode, shortcut, action, opts)
end

-- Directory
set_keymap("n", "<Leader>.", ":cd %:p:h<CR>", "Change directory to the current file's directory")

-- Window Management
set_keymap("n", "<A-Q>", ":wqa<CR>", "Save all files and quit Neovim")
set_keymap("n", "<C-Tab>", "<C-w>w", "Switch to the next window")

set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", "Decrease window width")
set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", "Increase window width")
set_keymap("n", "<C-Down>", ":resize +2<CR>", "Increase window height")
set_keymap("n", "<C-Up>", ":resize -2<CR>", "Decrease window height")

set_keymap("n", "<Left>", "<C-w>h", "Move to the left window")
set_keymap("n", "<Right>", "<C-w>l", "Move to the right window")
set_keymap("n", "<Down>", "<C-w>j", "Move to the window below")
set_keymap("n", "<Up>", "<C-w>k", "Move to the window above")
set_keymap("n", "<Leader>r", ":e<CR>", "Reload the current file")
set_keymap("n", "<Leader>x", ":q<CR>", "Quit the current window")

-- Tab Management
-- <C-t> is also the key that leaves terminal mode, so in a terminal buffer it
-- toggles keyboard ownership instead of opening a tab: terminal mode hands the
-- keyboard to Neovim, normal mode hands it back to the running program. Without
-- this, pressing it in a terminal that already sat in normal mode opened a blank
-- tab, which looks exactly like every mapping suddenly stopped working.
set_keymap("n", "<C-t>", function()
   if vim.bo.buftype == "terminal" then
      vim.cmd.startinsert()
   else
      vim.cmd.tabnew()
   end
end, "Open a new tab (in a terminal: return to the running program)")
set_keymap("n", "<S-h>", "<C-o>", "Jump to the previous location in the jump list")
set_keymap("n", "<S-l>", "<C-i>", "Jump to the next location in the jump list")
set_keymap("n", "<S-j>", ":tabprevious<CR>", "Switch to the previous tab")
set_keymap("n", "<S-k>", ":tabnext<CR>", "Switch to the next tab")
set_keymap("n", "<S-C-j>", ":tabm -1<CR>", "Move the current tab to the left")
set_keymap("n", "<S-C-k>", ":tabm +1<CR>", "Move the current tab to the right")
set_keymap("n", "<S-A-j>", ":tabm -1<CR>", "Move the current tab to the left")
set_keymap("n", "<S-A-k>", ":tabm +1<CR>", "Move the current tab to the right")

-- Cursor Navigation
set_keymap("n", "<A-k>", "`[", "Jump to the beginning of the last change")
set_keymap("n", "<A-j>", "`]", "Jump to the end of the last change")

-- Search keymaps are defined under editor domain keymaps

-- String manipulation
set_keymap("i", "<C-BS>", "<C-o>db", "Delete word before cursor")
set_keymap("i", "<C-Del>", "<C-o>dw", "Delete word after cursor")
set_keymap("i", "<C-Esc>", "<Esc>lxi", "Escape and replace character under cursor")
set_keymap("n", "<C-H>", "db", "Delete word before cursor in normal mode")

-- Highlight all and copy paste
set_keymap("n", "<C-a>", "gg<S-v>G", "Select all text")
set_keymap("v", "<C-c>", '"+y', "Copy selection to system clipboard")
set_keymap("v", "<C-v>", '"+p', "Paste from system clipboard")
set_keymap("x", "p", "P", "Paste without replacing the yank register")

-- Save and Save All
set_keymap("n", "<C-s>", ":w<CR>", "Save the current file")
set_keymap("n", "<C-S-s>", ":wa<CR>", "Save all files")

-- Code
set_keymap("n", "zf", ":foldclose<CR>", "Close fold")
set_keymap("n", "zo", ":foldopen<CR>", "Open fold")
