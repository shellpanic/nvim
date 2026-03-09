return {
   "nvim-telescope/telescope.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   keys = {
      { "<Leader>sf", ":Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find files" },
      { "<Leader>sg", ":Telescope live_grep<CR>", desc = "Live grep" },
      { "<Leader>sr", ":Telescope neoclip initial_mode=normal<CR>", desc = "Search clipboard history" },
      {
         "<Leader>sm",
         function()
            local ok = pcall(require, "telescope")
            if ok then
               vim.cmd("Telescope macroscope initial_mode=normal")
            end
         end,
         desc = "Search macros",
      },
   },
   config = function()
      require("telescope").setup({
         defaults = {
            mappings = {
               i = { ["<C-h>"] = "which_key" },
            },
         },
         pickers = {},
         extensions = {},
      })
   end,
}
