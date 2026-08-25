return {
   "nvim-flutter/flutter-tools.nvim",
   ft = { "dart" },
   dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
   },
   config = function()
      local common = require("plugins.lsp.common")
      require("flutter-tools").setup({
         lsp = { on_attach = common.on_attach, capabilities = common.capabilities },
      })
   end,
}
