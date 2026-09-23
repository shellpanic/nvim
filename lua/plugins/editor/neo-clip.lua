return {
   "AckslD/nvim-neoclip.lua",
   config = function()
      require("neoclip").setup({
         history = 1000,
         enable_persistent_history = false,
         preview = true,
         default_register = { '"', "+", "*" },
         initial_mode = "normal",
         on_select = {
            move_to_front = true,
            close_telescope = true,
         },
         on_paste = {
            set_reg = true,
            move_to_front = true,
            close_telescope = true,
         },
         keys = {
            telescope = {
               n = {
                  replay = "<C-q>",
               },
            },
         },
      })
   end,
}
