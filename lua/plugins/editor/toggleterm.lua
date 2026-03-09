return {
   "akinsho/toggleterm.nvim",
   version = "*",
   keys = {
      { "<Leader>t", ":ToggleTerm direction=tab<CR>", desc = "Open terminal in a new tab" },
      {
         "<Leader>tb",
         ":ToggleTerm direction=horizontal<CR>",
         desc = "Open terminal at bottom",
      },
      { "<Leader>xv", ":ToggleTermSendVisualSelection<CR>", mode = "v", desc = "Send selection to terminal" },
      {
         "<Leader>tg",
         function()
            _lazygit_toggle()
         end,
         desc = "Open lazygit tui",
      },
      {
         "<Leader>td",
         function()
            _lazydocker_toggle()
         end,
         desc = "Open lazydocker tui",
      },
      { "<C-t>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
   },
   config = function()
      require("toggleterm").setup({
         start_in_insert = false,
         float_opts = { border = "double" },
         title_pos = "center",
         on_open = function(term)
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
         float_opts = { border = "double" },
         on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
         end,
         on_close = function()
            vim.cmd("startinsert!")
         end,
      })

      local lazydocker = Terminal:new({
         cmd = "lazydocker",
         direction = "float",
         float_opts = { border = "double" },
         on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
         end,
         on_close = function()
            vim.cmd("startinsert!")
         end,
      })

      function _lazygit_toggle()
         lazygit:toggle()
      end

      function _lazydocker_toggle()
         lazydocker:toggle()
      end
   end,
}
