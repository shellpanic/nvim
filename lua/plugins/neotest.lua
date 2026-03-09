return {
   "nvim-neotest/neotest",
   dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   config = function()
      require("neotest").setup({
         adapters = {
            require("rustaceanvim.neotest"),
            require("neotest-python")({ dap = { justMyCode = false } }),
         },
         discovery = { enabled = false, concurrent = 0 },
         running = { concurrent = true },
         summary = { animated = true },
      })
   end,
}
