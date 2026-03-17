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
         local lsp_signature_cfg = { floating_windows = true, hint_enable = false, hint_prefix = "󰷻 " }
         local on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            lsp_signature.on_attach(lsp_signature_cfg, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            local p = "<Leader>l"
            vim.keymap.set("n", p .. "D", vim.lsp.buf.declaration, { desc = "LSP: Declaration", unpack(bufopts) })
            vim.keymap.set("n", p .. "d", vim.lsp.buf.definition, { desc = "LSP: Definition", unpack(bufopts) })
            vim.keymap.set("n", p .. "r", vim.lsp.buf.references, { desc = "LSP: References", unpack(bufopts) })
            vim.keymap.set("n", p .. "i", vim.lsp.buf.implementation, { desc = "LSP: Implementation", unpack(bufopts) })
            vim.keymap.set("n", p .. "h", vim.lsp.buf.hover, { desc = "LSP: Hover", unpack(bufopts) })
            vim.keymap.set("n", p .. "K", vim.lsp.buf.signature_help, { desc = "LSP: Signature help", unpack(bufopts) })
            vim.keymap.set(
               "n",
               p .. "wa",
               vim.lsp.buf.add_workspace_folder,
               { desc = "LSP: Workspace add", unpack(bufopts) }
            )
            vim.keymap.set(
               "n",
               p .. "wr",
               vim.lsp.buf.remove_workspace_folder,
               { desc = "LSP: Workspace remove", unpack(bufopts) }
            )
            vim.keymap.set("n", p .. "wl", function()
               print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, { desc = "LSP: Workspace list", unpack(bufopts) })
            vim.keymap.set(
               "n",
               p .. "t",
               vim.lsp.buf.type_definition,
               { desc = "LSP: Type definition", unpack(bufopts) }
            )
            vim.keymap.set(
               "n",
               p .. "e",
               vim.diagnostic.open_float,
               { desc = "LSP: Diagnostics float", unpack(bufopts) }
            )
            vim.keymap.set(
               "n",
               p .. "q",
               vim.diagnostic.setloclist,
               { desc = "LSP: Diagnostics loclist", unpack(bufopts) }
            )

            -- Keep function keys for rename/actions, and add leader aliases
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename", unpack(bufopts) })
            vim.keymap.set("n", p .. "rn", vim.lsp.buf.rename, { desc = "LSP: Rename", unpack(bufopts) })
            vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { desc = "LSP: Code actions", unpack(bufopts) })
            vim.keymap.set("n", p .. "a", vim.lsp.buf.code_action, { desc = "LSP: Code actions", unpack(bufopts) })

            -- Formatting under code group too, but provide LSP alias
            vim.keymap.set("n", p .. "f", function()
               vim.lsp.buf.format({ async = true })
            end, { desc = "LSP: Format", unpack(bufopts) })

            -- Show signature help automatically on CursorHold in normal mode
            local group = vim.api.nvim_create_augroup("LspSignatureOnHold" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
               group = group,
               buffer = bufnr,
               callback = function()
                  if vim.fn.mode() == "n" then
                     pcall(function()
                        lsp_signature.signature({})
                     end)
                  end
               end,
            })
         end

         local lua_ls_setup = {
            Lua = {
               runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
               diagnostics = { globals = { "vim" } },
               workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
               completion = { callSnippet = "Both" },
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
            init_options = {
               preferences = {
                  includeCompletionsWithSnippetText = true,
                  includeCompletionsWithInsertTextCompletions = true,
               },
            },
         })
         vim.lsp.enable("ts_ls")

         require("flutter-tools").setup({ lsp = { on_attach = on_attach, capabilities = capabilities } })

         -- Configure standard servers
         for _, name in ipairs({ "taplo", "bashls", "vue_ls", "dockerls", "docker_compose_language_service" }) do
            vim.lsp.config(name, { on_attach = on_attach, capabilities = capabilities })
            vim.lsp.enable(name)
         end

         -- Python: BasedPyright with inlay hints and workspace diagnostics
         vim.lsp.config("basedpyright", {
            on_attach = on_attach,
            capabilities = capabilities,
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

         -- Python: use Ruff's built-in LSP (preferred over deprecated ruff-lsp)
         vim.lsp.config("ruff", {
            on_attach = on_attach,
            capabilities = capabilities,
            init_options = { settings = { args = {} } },
         })
         vim.lsp.enable("ruff")

         -- YAML: enable schema store and Docker Compose schemas
         vim.lsp.config("yamlls", {
            on_attach = on_attach,
            capabilities = capabilities,
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

         -- Override marksman to avoid unknown filetype 'markdown.mdx'
         vim.lsp.config("marksman", {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "markdown" },
         })
         vim.lsp.enable("marksman")

         -- Reduce LSP log noise and file size
         pcall(vim.lsp.set_log_level, "ERROR")

         -- Prefer minimal virtual text by default (warn/error only)
         pcall(vim.diagnostic.config, {
            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
         })

         -- Diagnostics enabled by default; uncomment to disable
         -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
      end,
   },
}
