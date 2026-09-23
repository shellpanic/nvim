return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         { "ray-x/lsp_signature.nvim", event = "VeryLazy" },
      },
      config = function()
         local common = require("plugins.lsp.common")
         local servers = {
            lua_ls = {
               settings = {
                  Lua = {
                     runtime = { version = "LuaJIT" },
                     diagnostics = { globals = { "vim" } },
                     workspace = { checkThirdParty = false },
                     completion = { callSnippet = "Both" },
                     telemetry = { enable = false },
                  },
               },
            },
            taplo = {},
            bashls = {},
            vue_ls = {},
            dockerls = {},
         }

         for _, module in ipairs({
            "plugins.lsp.lang.typescript",
            "plugins.lsp.lang.python",
            "plugins.lsp.lang.yaml",
            "plugins.lsp.lang.markdown",
         }) do
            for name, config in pairs(require(module)) do
               servers[name] = config
            end
         end

         for name, config in pairs(servers) do
            vim.lsp.config(
               name,
               vim.tbl_deep_extend("force", {
                  on_attach = common.on_attach,
                  capabilities = common.capabilities,
               }, config)
            )
            vim.lsp.enable(name)
         end

         -- Diagnostics defaults
         vim.lsp.log.set_level("ERROR")
         vim.diagnostic.config({
            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
         })
      end,
   },
}
