return {
   "toppair/peek.nvim",
   event = { "VeryLazy" },
   build = "deno task --quiet build:fast",
   config = function()
      require("peek").setup({
         auto_load = true,
         close_on_bdelete = true,
         syntax = true,
         theme = "dark",
         update_on_change = true,
         app = { "firefox", "--new-window" },
         filetype = { "markdown" },
         throttle_at = 200000,
         throttle_time = "auto",
      })
      vim.api.nvim_create_user_command("PeekOpen", function()
         require("peek").open()
      end, {})
      vim.api.nvim_create_user_command("PeekClose", function()
         require("peek").close()
      end, {})
   end,
}
