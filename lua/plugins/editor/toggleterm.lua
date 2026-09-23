return {
   "akinsho/toggleterm.nvim",
   version = "*",
   cmd = { "ToggleTerm", "ToggleTermSendVisualSelection", "LazyGitToggle", "LazyDockerToggle" },
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

      local function name_tab(term, name)
         vim.api.nvim_buf_call(term.bufnr, function()
            vim.cmd("silent noautocmd file term://" .. name)
         end)
      end

      local lazygit = Terminal:new({
         cmd = "lazygit",
         dir = "git_dir",
         direction = "tab",
         display_name = "git",
         on_open = function(term)
            name_tab(term, "git")
            vim.cmd("startinsert!")
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true, desc = "Close LazyGit" })
         end,
      })

      local lazydocker = Terminal:new({
         cmd = "lazydocker",
         direction = "tab",
         display_name = "docker",
         on_open = function(term)
            name_tab(term, "docker")
            vim.cmd("startinsert!")
            vim.keymap.set(
               "n",
               "q",
               "<cmd>close<CR>",
               { buffer = term.bufnr, silent = true, desc = "Close LazyDocker" }
            )
         end,
      })

      -- user commands so mappings can live in domain keymaps
      vim.api.nvim_create_user_command("LazyGitToggle", function()
         lazygit:toggle()
      end, { force = true })
      vim.api.nvim_create_user_command("LazyDockerToggle", function()
         lazydocker:toggle()
      end, { force = true })
   end,
}
