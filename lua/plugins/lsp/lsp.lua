return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "folke/neodev.nvim",
         "hrsh7th/cmp-nvim-lsp",
         { "ray-x/lsp_signature.nvim", event = "VeryLazy" },
      },
      config = function()
         require("neodev").setup({
            library = { enabled = true, runtime = true, types = true, plugins = { "nvim-dap-ui" } },
            setup_jsonls = true,
            override = function() end,
            lspconfig = true,
            pathStrict = true,
         })

         local common = require("plugins.lsp.common")

         -- Built-in LSP (0.11+): Lua
         local lua_ls_setup = {
            Lua = {
               runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
               diagnostics = { globals = { "vim" } },
               workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
               completion = { callSnippet = "Both" },
               telemetry = { enable = false },
            },
         }
         vim.lsp.config("lua_ls", {
            on_attach = common.on_attach,
            capabilities = common.capabilities,
            settings = lua_ls_setup,
         })
         vim.lsp.enable("lua_ls")

         -- Flutter tools still uses shared on_attach/capabilities
         pcall(function()
            require("flutter-tools").setup({
               lsp = { on_attach = common.on_attach, capabilities = common.capabilities },
            })
         end)

         -- Simple servers with no special config
         for _, name in ipairs({ "taplo", "bashls", "vue_ls", "dockerls" }) do
            vim.lsp.config(name, { on_attach = common.on_attach, capabilities = common.capabilities })
            vim.lsp.enable(name)
         end

         -- Diagnostics defaults
         pcall(vim.lsp.set_log_level, "ERROR")
         pcall(vim.diagnostic.config, {
            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
         })
      end,
   },
}
