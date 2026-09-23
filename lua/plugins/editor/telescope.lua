return {
   "nvim-telescope/telescope.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   cmd = { "Telescope" },
   config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
         defaults = {
            mappings = {
               i = { ["<C-h>"] = "which_key" },
               n = { ["q"] = actions.close },
            },
         },
         pickers = {},
         extensions = {},
      })
   end,
}
