local vue_language_server = vim.fs.joinpath(
   vim.fn.stdpath("data"),
   "mason",
   "packages",
   "vue-language-server",
   "node_modules",
   "@vue",
   "language-server"
)

return {
   vtsls = {
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      settings = {
         vtsls = {
            tsserver = {
               globalPlugins = {
                  {
                     name = "@vue/typescript-plugin",
                     location = vue_language_server,
                     languages = { "vue" },
                     configNamespace = "typescript",
                  },
               },
            },
         },
         javascript = { suggest = { completeFunctionCalls = false } },
         typescript = { suggest = { completeFunctionCalls = false } },
      },
   },
}
