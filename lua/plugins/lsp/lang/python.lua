return {
   {
      "neovim/nvim-lspconfig",
      ft = { "python" },
      config = function()
         local common = require("plugins.lsp.common")
         -- BasedPyright
         vim.lsp.config("basedpyright", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            settings = {
               python = {
                  analysis = {
                     typeCheckingMode = "basic",
                     autoImportCompletions = true,
                     diagnosticMode = "workspace",
                     inlayHints = {
                        variableTypes = true,
                        functionReturnTypes = true,
                        parameterNames = "all",
                        parameterTypes = true,
                     },
                  },
               },
            },
         })
         vim.lsp.enable("basedpyright")

         -- Ruff LSP
         vim.lsp.config("ruff", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            init_options = { settings = { args = {} } },
         })
         vim.lsp.enable("ruff")
      end,
   },
}
