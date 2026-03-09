return {
   "johnseth97/codex.nvim",
   lazy = true,
   cmd = { "Codex", "CodexToggle" },
   keys = {
      {
         "<leader>ccc",
         function()
            require("codex").toggle()
         end,
         desc = "Toggle Codex popup",
      },
   },
   opts = {
      keymaps = {},
      border = "double",
      width = 0.8,
      height = 0.8,
      model = nil,
      autoinstall = false,
   },
}
