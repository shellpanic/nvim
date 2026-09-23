return {
   "folke/sidekick.nvim",
   cmd = { "Sidekick" },
   opts = {
      -- The CLI integration works without a Copilot subscription. Keep NES opt-in.
      nes = { enabled = false },
      cli = {
         watch = true,
         picker = "telescope",
         win = {
            layout = "right",
            split = { width = 80 },
            keys = {
               stopinsert = { "<C-t>", "stopinsert", mode = "t", desc = "Enter Neovim normal mode" },
            },
         },
      },
   },
}
