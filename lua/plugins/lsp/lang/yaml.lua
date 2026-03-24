return {
   {
      "neovim/nvim-lspconfig",
      ft = { "yaml" },
      config = function()
         local common = require("plugins.lsp.common")
         vim.lsp.config("yamlls", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            filetypes = { "yaml" },
            settings = {
               yaml = {
                  completion = true,
                  validate = true,
                  hover = true,
                  format = { enable = false },
                  schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
                  schemas = {
                     ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                        "docker-compose*.yml",
                        "docker-compose*.yaml",
                        "compose*.yml",
                        "compose*.yaml",
                     },
                  },
               },
            },
         })
         vim.lsp.enable("yamlls")
      end,
   },
}
