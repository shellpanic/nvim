return {
   {
      "neovim/nvim-lspconfig",
      ft = { "markdown" },
      config = function()
         local common = require("plugins.lsp.common")
         vim.lsp.config("marksman", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            filetypes = { "markdown" },
         })
         vim.lsp.enable("marksman")
      end,
   },
}
