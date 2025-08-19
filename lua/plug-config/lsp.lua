local lspconfig = require("lspconfig")
local lsp_signature = require("lsp_signature")

-- Better signature visualisation - Config
local lsp_signature_cfg = {
   floating_windows = true, -- virtual only
   hint_enable = true, -- virtual hint enable
   hint_prefix = "󰷻 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
   lsp_signature.on_attach(lsp_signature_cfg, bufnr)

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   local bufopts = { noremap = true, silent = true, buffer = bufnr }

   local lsp_prefix = "<Leader>l"
   vim.keymap.set("n", lsp_prefix .. "D", vim.lsp.buf.declaration, { desc = "Go to declaration", unpack(bufopts) })
   vim.keymap.set("n", lsp_prefix .. "d", vim.lsp.buf.definition, { desc = "Go to definition", unpack(bufopts) })
   vim.keymap.set("n", lsp_prefix .. "r", vim.lsp.buf.references, { desc = "Find references", unpack(bufopts) })
   vim.keymap.set(
      "n",
      lsp_prefix .. "i",
      vim.lsp.buf.implementation,
      { desc = "Go to implementation", unpack(bufopts) }
   )
   vim.keymap.set("n", "C-S-o", vim.lsp.buf.hover, { desc = "Show hover information", unpack(bufopts) })
   vim.keymap.set("n", "<C-p>", vim.lsp.buf.signature_help, { desc = "Show signature help", unpack(bufopts) })
   vim.keymap.set(
      "n",
      lsp_prefix .. "wa",
      vim.lsp.buf.add_workspace_folder,
      { desc = "Add workspace folder", unpack(bufopts) }
   )
   vim.keymap.set(
      "n",
      lsp_prefix .. "wr",
      vim.lsp.buf.remove_workspace_folder,
      { desc = "Remove workspace folder", unpack(bufopts) }
   )
   vim.keymap.set("n", lsp_prefix .. "wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, { desc = "List workspace folders", unpack(bufopts) })
   vim.keymap.set(
      "n",
      lsp_prefix .. "td",
      vim.lsp.buf.type_definition,
      { desc = "Go to type definition", unpack(bufopts) }
   )
   vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol", unpack(bufopts) })
   vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { desc = "Show code actions", unpack(bufopts) })
   vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
   end, { desc = "Format code", unpack(bufopts) })

   -- Diagnostics
   vim.keymap.set(
      "n",
      lsp_prefix .. "e",
      vim.diagnostic.open_float,
      { desc = "Show diagnostics in a floating window", unpack(bufopts) }
   )
   vim.keymap.set(
      "n",
      lsp_prefix .. "q",
      vim.diagnostic.setloclist,
      { desc = "Set location list with diagnostics", unpack(bufopts) }
   )
   -- Leads to issues with warning: No more valid diagnostics to move to
   -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev(), bufopts)
   -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next(), bufopts)
end

-- Fix warning "Undefined global variable "vim"
local lua_ls_setup = {
   Lua = {
      runtime = {
         version = "LuaJIT",
         -- Setup Neovim runtime path
         path = vim.split(package.path, ";"),
      },
      diagnostics = {
         globals = { "vim" },
      },
      workspace = {
         library = vim.api.nvim_get_runtime_file("", true),
         checkThirdParty = false,
      },
      telemetry = {
         enable = false,
      },
   },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({
   on_attach = on_attach,
   capabilities = capabilities,
   settings = lua_ls_setup,
})

-- Vue LSP setup
local mason_registry = require("mason-registry")

local vue_language_server_path = nil
local vue_package = mason_registry.get_package("vue-language-server")

if not vue_package.spec then
   vim.api.nvim_echo({ { "spec not here...hmpf", "ErrorMsg" } }, true, {})
end
if vue_package and vue_package.spec.install_path then
   vue_language_server_path = vue_package.spec.install_path .. "/node_modules/@vue/language-server"
else
   -- vim.api.nvim_echo({ { "Vue LSP path missing or invalid", "ErrorMsg" } }, true, {})
end

if vue_language_server_path then
   lspconfig.ts_ls.setup({
      init_options = {
         plugins = {
            {
               name = "@vue/typescript-plugin",
               location = vue_language_server_path,
               languages = { "vue" },
            },
         },
      },
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
   })
end

-- Flutter LSP setup

require("flutter-tools").setup({
   lsp = {
      on_attach = on_attach,
      capabilities = capabilities,
   },
})

-- Generic LSP server setup
local servers = {
   "basedpyright",
   "taplo",
   "bashls",
   "volar",
   "marksman",
}

for _, lsp in pairs(servers) do
   lspconfig[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
   })
end

-- Deactivate lsp diagnostics like "E501 Line to long"
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
