require("toggleterm").setup({
   start_in_insert = false,
   float_opts = {
      border = "double",
   },
   title_pos = "center",
   on_open = function(term)
      -- Many terminals do not distinguish <S-CR> from <CR>.
      -- Provide a reliable multiline insert: Ctrl+J pastes a literal newline
      -- via bracketed paste so interactive TUIs treat it as text, not submit.
      local function paste_newline()
         local nl_paste = "\x1b[200~\n\x1b[201~"
         if term and term.job_id then
            vim.fn.chansend(term.job_id, nl_paste)
         end
      end
      vim.keymap.set(
         "t",
         "<C-j>",
         paste_newline,
         { buffer = term.bufnr, silent = true, desc = "Insert newline (paste) in terminal" }
      )
   end,
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
   cmd = "lazygit",
   dir = "git_dir",
   direction = "float",
   float_opts = {
      border = "double",
   },
   -- function to run on opening the terminal
   on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      -- Do NOT override keys inside lazygit; it manages its own input.
   end,
   -- function to run on closing the terminal
   on_close = function(term)
      vim.cmd("startinsert!")
   end,
})

local lazydocker = Terminal:new({
   cmd = "lazydocker",
   direction = "float",
   float_opts = {
      border = "double",
   },
   -- function to run on opening the terminal
   on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      -- Do NOT override keys inside lazydocker; it manages its own input.
   end,
   -- function to run on closing the terminal
   on_close = function(term)
      vim.cmd("startinsert!")
   end,
})

function _lazygit_toggle()
   lazygit:toggle()
end

function _lazydocker_toggle()
   lazydocker:toggle()
end
