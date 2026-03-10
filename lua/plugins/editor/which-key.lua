return {
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      cmd = { "WhichKey", "WhichKeyBuffer" },
      config = function(_, opts)
         local wk = require("which-key")
         wk.setup(opts)

         -- New which-key spec (array form)
         wk.add({
            { "<leader>?", desc = "WhichKey (buffer)" },
            { "<leader>a", group = "AI" },
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Debug" },
            { "<leader>e", group = "Editor" },
            { "<leader>l", group = "LSP" },
            { "<leader>m", group = "Misc" },
            { "<leader>r", desc = "Reload file" },
            { "<leader>s", group = "Search" },
            { "<leader>t", group = "Terminal" },
            { "<leader>u", group = "Tests" },
            { "<leader>x", desc = "Quit window" },
         })

         -- Visual mode groups using new spec
         wk.add({
            {
               mode = { "v" },
               { "<leader>a", group = "AI" },
               { "<leader>c", group = "Code" },
               { "<leader>e", group = "Editor" },
               { "<leader>m", group = "Misc" },
               { "<leader>s", group = "Search" },
            },
         })
         vim.api.nvim_create_user_command("WhichKeyBuffer", function()
            wk.show({ global = false })
         end, {})
      end,
   },
}
