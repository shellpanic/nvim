return {
   {
      -- Typescript/JavaScript via builtin LSP config
      "neovim/nvim-lspconfig",
      ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
      config = function()
         local common = require("plugins.lsp.common")
         vim.lsp.config("ts_ls", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
            init_options = {
               preferences = {
                  includeCompletionsWithSnippetText = false,
                  includeCompletionsWithInsertTextCompletions = false,
               },
            },
         })
         vim.lsp.enable("ts_ls")
      end,
   },
}
