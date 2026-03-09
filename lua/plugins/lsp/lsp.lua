return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "folke/neodev.nvim",
         "hrsh7th/cmp-nvim-lsp",
         { "ray-x/lsp_signature.nvim", event = "VeryLazy" },
         { "linrongbin16/lsp-progress.nvim" },
      },
      config = function()
         require("lsp-progress").setup()
         require("neodev").setup({
            library = {
               enabled = true,
               runtime = true,
               types = true,
               plugins = { "nvim-dap-ui" },
            },
            setup_jsonls = true,
            override = function() end,
            lspconfig = true,
            pathStrict = true,
         })

         local lsp_signature = require("lsp_signature")
         local lsp_signature_cfg = { floating_windows = true, hint_enable = true, hint_prefix = "󰷻 " }
         local on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            lsp_signature.on_attach(lsp_signature_cfg, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            local p = "<Leader>l"
            vim.keymap.set("n", p .. "D", vim.lsp.buf.declaration, { desc = "Go to declaration", unpack(bufopts) })
            vim.keymap.set("n", p .. "d", vim.lsp.buf.definition, { desc = "Go to definition", unpack(bufopts) })
            vim.keymap.set("n", p .. "r", vim.lsp.buf.references, { desc = "Find references", unpack(bufopts) })
            vim.keymap.set(
               "n",
               p .. "i",
               vim.lsp.buf.implementation,
               { desc = "Go to implementation", unpack(bufopts) }
            )
            vim.keymap.set("n", "C-S-o", vim.lsp.buf.hover, { desc = "Show hover information", unpack(bufopts) })
            vim.keymap.set("n", "<C-p>", vim.lsp.buf.signature_help, { desc = "Show signature help", unpack(bufopts) })
            vim.keymap.set(
               "n",
               p .. "wa",
               vim.lsp.buf.add_workspace_folder,
               { desc = "Add workspace folder", unpack(bufopts) }
            )
            vim.keymap.set(
               "n",
               p .. "wr",
               vim.lsp.buf.remove_workspace_folder,
               { desc = "Remove workspace folder", unpack(bufopts) }
            )
            vim.keymap.set("n", p .. "wl", function()
               print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, { desc = "List workspace folders", unpack(bufopts) })
            vim.keymap.set(
               "n",
               p .. "td",
               vim.lsp.buf.type_definition,
               { desc = "Go to type definition", unpack(bufopts) }
            )
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol", unpack(bufopts) })
            vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { desc = "Show code actions", unpack(bufopts) })
            vim.keymap.set("n", "<space>f", function()
               vim.lsp.buf.format({ async = true })
            end, { desc = "Format code", unpack(bufopts) })
            vim.keymap.set("n", p .. "e", vim.diagnostic.open_float, { desc = "Show diagnostics", unpack(bufopts) })
            vim.keymap.set("n", p .. "q", vim.diagnostic.setloclist, { desc = "Diagnostics loclist", unpack(bufopts) })
         end

         local lua_ls_setup = {
            Lua = {
               runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
               diagnostics = { globals = { "vim" } },
               workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
               telemetry = { enable = false },
            },
         }

         local capabilities = require("cmp_nvim_lsp").default_capabilities()

         -- Built-in LSP (0.11+)
         vim.lsp.config("lua_ls", { on_attach = on_attach, capabilities = capabilities, settings = lua_ls_setup })
         vim.lsp.enable("lua_ls")

         -- Configure TypeScript/JavaScript separately from Vue to avoid overlap
         vim.lsp.config("ts_ls", {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
         })
         vim.lsp.enable("ts_ls")

         require("flutter-tools").setup({ lsp = { on_attach = on_attach, capabilities = capabilities } })

         -- Configure standard servers
         for _, name in ipairs({ "basedpyright", "taplo", "bashls", "vue_ls" }) do
            vim.lsp.config(name, { on_attach = on_attach, capabilities = capabilities })
            vim.lsp.enable(name)
         end

         -- Override marksman to avoid unknown filetype 'markdown.mdx'
         vim.lsp.config("marksman", {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "markdown" },
         })
         vim.lsp.enable("marksman")

         -- Reduce LSP log noise and file size
         pcall(vim.lsp.set_log_level, "ERROR")

         -- Diagnostics enabled by default; uncomment to disable
         -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
      end,
   },
}
