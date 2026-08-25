return {
   "lewis6991/gitsigns.nvim",
   event = { "BufReadPre", "BufNewFile" },
   opts = {
      signs_staged_enable = true,
      current_line_blame = false,
      on_attach = function(buffer)
         local gitsigns = require("gitsigns")
         local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buffer, silent = true, desc = desc })
         end

         map("n", "]h", function()
            gitsigns.nav_hunk("next")
         end, "Git: Next hunk")
         map("n", "[h", function()
            gitsigns.nav_hunk("prev")
         end, "Git: Previous hunk")
         map("n", "<leader>gn", function()
            gitsigns.nav_hunk("next")
         end, "Git: Next hunk")
         map("n", "<leader>gp", function()
            gitsigns.nav_hunk("prev")
         end, "Git: Previous hunk")
         map("n", "<leader>gv", gitsigns.preview_hunk_inline, "Git: Preview hunk")
         map("n", "<leader>gs", gitsigns.stage_hunk, "Git: Stage hunk")
         map("x", "<leader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
         end, "Git: Stage selection")
         map("n", "<leader>gr", gitsigns.reset_hunk, "Git: Reset hunk")
         map("x", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
         end, "Git: Reset selection")
         map("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
         end, "Git: Blame line")
         map("n", "<leader>gd", gitsigns.diffthis, "Git: Diff file")
      end,
   },
}
