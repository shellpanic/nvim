return {
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
      cmd = { "WhichKey", "WhichKeyBuffer" },
      config = function(_, opts)
         local wk = require("which-key")
         wk.setup(opts)

         -- Group names and helpful labels under <leader>
         wk.register({
            ["<leader>"] = {
               a = { name = "AI" },
               s = { name = "Search" },
               t = { name = "Terminal" },
               u = { name = "Tests" },
               l = { name = "LSP" },
               d = { name = "Debug" },
               c = { name = "Code" },
               e = { name = "Editor" },
               m = { name = "Misc" },
               r = { "Reload file" },
               x = { "Quit window" },
               ["?"] = { "WhichKey (buffer)" },
            },
         }, { mode = "n" })

         -- Visual-mode group names where relevant
         wk.register({
            ["<leader>"] = {
               a = { name = "AI" },
               s = { name = "Search" },
               c = { name = "Code" },
               e = { name = "Editor" },
               m = { name = "Misc" },
            },
         }, { mode = "v" })
         vim.api.nvim_create_user_command("WhichKeyBuffer", function()
            wk.show({ global = false })
         end, {})
      end,
   },
}
