local default_options = { noremap = true, silent = true, nowait = false }
local function set_keymap(mode, shortcut, action, description, opts)
   opts = vim.tbl_extend("force", opts or {}, { desc = description, unpack(default_options) })
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
set_keymap("n", "<C-t>", ":tabnew<CR>", "Open a new tab")
set_keymap("n", "<S-h>", "<C-o>", "Jump to the previous location in the jump list")
set_keymap("n", "<S-l>", "<C-i>", "Jump to the next location in the jump list")
set_keymap("n", "<S-j>", ":tabprevious<CR>", "Switch to the previous tab")
set_keymap("n", "<S-k>", ":tabnext<CR>", "Switch to the next tab")
set_keymap("n", "<S-C-j>", ":tabm -1<CR>", "Move the current tab to the left")
set_keymap("n", "<S-C-k>", ":tabm +1<CR>", "Move the current tab to the right")

-- Cursor Navigation
set_keymap("n", "<A-k>", "`[", "Jump to the beginning of the last change")
set_keymap("n", "<A-j>", "`]", "Jump to the end of the last change")

-- Search
local search_prefix = "<Leader>s"

set_keymap("n", search_prefix, ":noh<CR>", "Clear search highlight")
set_keymap("n", search_prefix .. "f", ":Telescope find_files hidden=true no_ignore=true<CR>", "Find files")
set_keymap("n", search_prefix .. "g", ":Telescope live_grep<CR>", "Live grep")
set_keymap("n", search_prefix .. "r", ":Telescope neoclip initial_mode=normal<CR>", "Search clipboard history")
set_keymap("n", search_prefix .. "m", ":Telescope macroscope initial_mode=normal<CR>", "Search macros")

-- String manipulation
set_keymap("i", "<C-BS>", "<C-o>db", "Delete word before cursor")
set_keymap("i", "<C-Del>", "<C-o>dw", "Delete word after cursor")
set_keymap("i", "<C-Esc>", "<Esc>lxi", "Escape and replace character under cursor")
set_keymap("n", "<C-H>", "db", "Delete word before cursor in normal mode")

-- Highlight all and copy paste
set_keymap("n", "<C-a>", "gg<S-v>G", "Select all text")
set_keymap("v", "<C-c>", '"+y', "Copy selection to system clipboard")
set_keymap("v", "<C-v>", '"+p', "Paste from system clipboard")

-- Save and Save All
set_keymap("n", "<C-s>", ":w<CR>", "Save the current file")
set_keymap("n", "<C-S-s>", ":wa<CR>", "Save all files")

-- Style
set_keymap("n", "<Leader>c", ":PickColor<CR>", "Pick a color")
set_keymap("i", "<C-Leader>c", ":PickColorInsert<CR>", "Pick a color in insert mode")

-- Formatting and Linting
local conform = require("conform")
local lint = require("lint")

set_keymap({ "n", "v" }, "<Leader>mp", function()
   conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
   })
end, "Format file or range (in visual mode)")

set_keymap("n", "<C-ll>", function()
   lint.try_lint()
end, "Trigger linting for current file")

-- Code
set_keymap("n", "zf", ":foldclose<CR>", "Close fold")
set_keymap("n", "zo", ":foldopen<CR>", "Open fold")

-- Neo-Tree
set_keymap("n", "<C-n>", ":Neotree toggle<CR>", "Toggle Neo-Tree")
set_keymap("n", "<Leader>n", ":Neotree focus<CR>", "Focus Neo-Tree")
set_keymap("n", "<Leader><Tab>", ":Neotree buffers float toggle reveal dir=./ selector<CR>", "Toggle Neo-Tree buffers")

-- Outline
set_keymap("n", "<Leader>o", ":AerialToggle<CR>", "Toggle Outline")

-- LSP
local lsp_signature = require("lsp_signature")
set_keymap("n", "<Leader>ls", function()
   lsp_signature.toggle_float_win()
end, "Toggle LSP signature floating window")

-- Copilot
local copilot_prefix = "<Leader>c"

set_keymap("n", copilot_prefix .. "c", ":CopilotChatToggle<CR>", "Toggle Copilot Chat")
set_keymap("n", copilot_prefix .. "cr", ":CopilotChatReset<CR>", "Reset Copilot Chat")
set_keymap("v", copilot_prefix .. "cs", ":CopilotChat<CR>", "Start Copilot Chat with selection")
-- set_keymap("n", copilot_prefix .. "cq", function()
--    local input = vim.fn.input("Quick Chat: ")
--    if input ~= "" then
--       require("CopilotChat").ask(input, {
--          selection = require("CopilotChat.select").buffer,
--       })
--    end
-- end, "CopilotChat - Quick chat about buffer")

-- Terminal
local terminal_prefix = "<Leader>t" -- terminal

set_keymap("t", "<C-t>", "<C-\\><C-n>", "Exit terminal mode")
set_keymap("n", terminal_prefix, ":ToggleTerm direction=tab<CR>", "Open terminal in a new tab")
set_keymap(
   "n",
   terminal_prefix .. "b",
   ":ToggleTerm direction=horizontal<CR>",
   "Open terminal at the bottom of the screen"
)
set_keymap("v", terminal_prefix .. "xv", ":ToggleTermSendVisualSelection<CR>", "Send visual selection to terminal")
set_keymap("n", terminal_prefix .. "g", "<cmd>lua _lazygit_toggle()<CR>", "Open lazygit tui")
set_keymap("n", terminal_prefix .. "d", "<cmd>lua _lazydocker_toggle()<CR>", "Open lazydocker tui")

-- Test Framework
local neotest = require("neotest")
local test_prefix = "<Leader>i" -- inspect

set_keymap(
   "n",
   test_prefix .. "wf",
   ':lua require"neotest".watch.toggle(vim.fn.expand("%"))<CR>',
   "Toggle watch for the current file"
)
set_keymap("n", test_prefix .. "s", ':lua require"neotest".summary.toggle()<CR>', "Toggle test summary")
set_keymap("n", test_prefix .. "sn", ':lua require"neotest".run.stop()<CR>', "Stop the current test run")
set_keymap("n", test_prefix .. "w", ':lua require"neotest".watch.toggle()<CR>', "Toggle watch for tests")
set_keymap("n", test_prefix .. "r", ':lua require"neotest".run.run()<CR><Esc>', "Run tests")
set_keymap("n", test_prefix .. "o", ':lua require"neotest".output.open({ enter = true })<CR>', "Open test output")
set_keymap(
   "n",
   test_prefix .. "os",
   ':lua require"neotest".output.open({ short = true, enter = true })<CR>',
   "Open short test output"
)
set_keymap("n", test_prefix .. "op", ':lua require"neotest".output_panel.toggle()<CR>', "Toggle test output panel")
set_keymap("n", test_prefix .. "oc", ':lua require"neotest".output_panel.clear()<CR>', "Clear test output panel")
set_keymap(
   "n",
   test_prefix .. "rf",
   ':lua require"neotest".run.run(vim.fn.expand("%"))<CR>',
   "Run tests in the current file"
)
set_keymap("n", test_prefix .. "d", ':lua require"neotest".run.run({ strategy = "dap" })<CR>', "Run tests with DAP")
set_keymap(
   "n",
   test_prefix .. "df",
   ':lua require"neotest".run.run(vim.fn.expand("%"), { strategy = "dap" })<CR>',
   "Run tests in the current file with DAP"
)
set_keymap("n", test_prefix .. "a", ':lua require"neotest".run.attach()<CR>', "Attach to the current test run")

-- Debugger
local dap_python = require("dap-python")

set_keymap("n", "<Leader>db", ':lua require"dap".toggle_breakpoint()<CR>', "Toggle breakpoint")
set_keymap("n", "<Leader>dpr", function()
   dap_python.test_method()
end, "Run Python test method with DAP")
set_keymap("n", "<F3>", ':lua require"dap".terminate()<CR>', "Terminate debugging session")
set_keymap("n", "<F5>", ':lua require"dap".continue()<CR>', "Continue debugging")
set_keymap("n", "<F10>", ':lua require"dap".step_over()<CR>', "Step over")
set_keymap("n", "<F11>", ':lua require"dap".step_into()<CR>', "Step into")
set_keymap("n", "<F12>", ':lua require"dap".step_out()<CR>', "Step out")
