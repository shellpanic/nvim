return {
   "saecki/crates.nvim",
   event = { "BufRead Cargo.toml", "BufNewFile Cargo.toml" },
   dependencies = { "nvim-lua/plenary.nvim" },
   config = function()
      local common = require("plugins.lsp.common")
      require("crates").setup({
         lsp = {
            enabled = true,
            actions = true,
            completion = true,
            hover = true,
            on_attach = common.on_attach,
         },
      })
   end,
}
