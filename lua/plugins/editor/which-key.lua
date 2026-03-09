return {
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      cmd = { "WhichKey", "WhichKeyBuffer" },
      config = function(_, opts)
         require("which-key").setup(opts)
         vim.api.nvim_create_user_command("WhichKeyBuffer", function()
            require("which-key").show({ global = false })
         end, {})
      end,
   },
}
