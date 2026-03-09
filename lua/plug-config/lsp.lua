local lsp_signature = require("lsp_signature")

-- Better signature visualisation - Config
local lsp_signature_cfg = {
   floating_windows = true,
   hint_enable = true,
   hint_prefix = "󰷻 ",
}

-- on_attach
local on_attach = function(_, bufnr)
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
   lsp_signature.on_attach(lsp_signature_cfg, bufnr)

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
end

-- lua_ls settings
local lua_ls_setup = {
   Lua = {
      runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      telemetry = { enable = false },
   },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lua_ls: register + enable
vim.lsp.config("lua_ls", {
   on_attach = on_attach,
   capabilities = capabilities,
   settings = lua_ls_setup,
})
vim.lsp.enable("lua_ls")

-- Vue / TypeScript: ts_ls mit @vue/typescript-plugin
local mason_registry = require("mason-registry")

local vue_language_server_path ---@type string|nil
local ok, vue_pkg = pcall(mason_registry.get_package, "vue-language-server")
if ok and vue_pkg then
   local install_path = (vue_pkg.get_install_path and vue_pkg:get_install_path()) or nil
   if install_path then
      vue_language_server_path = install_path .. "/node_modules/@vue/language-server"
   end
end

if vue_language_server_path then
   vim.lsp.config("ts_ls", {
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
   vim.lsp.enable("ts_ls")
end

-- Flutter
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
   "rust_analyzer",
   "vue_ls",
   "marksman",
}

for _, name in ipairs(servers) do
   vim.lsp.config(name, {
      on_attach = on_attach,
      capabilities = capabilities,
   })
   vim.lsp.enable(name)
end

-- Diagnostics are enabled by default; comment the line below back in to disable globally
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
