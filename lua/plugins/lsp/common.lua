local M = {}

local function build_on_attach()
   local lsp_signature = require("lsp_signature")
   local lsp_signature_cfg = { floating_windows = true, hint_enable = false, hint_prefix = "󰷻 " }

   return function(_, bufnr)
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
      vim.keymap.set("n", p .. "wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: Workspace add", unpack(bufopts) })
      vim.keymap.set(
         "n",
         p .. "wr",
         vim.lsp.buf.remove_workspace_folder,
         { desc = "LSP: Workspace remove", unpack(bufopts) }
      )
      vim.keymap.set("n", p .. "wl", function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { desc = "LSP: Workspace list", unpack(bufopts) })
      vim.keymap.set("n", p .. "t", vim.lsp.buf.type_definition, { desc = "LSP: Type definition", unpack(bufopts) })
      vim.keymap.set("n", p .. "e", vim.diagnostic.open_float, { desc = "LSP: Diagnostics float", unpack(bufopts) })
      vim.keymap.set("n", p .. "q", vim.diagnostic.setloclist, { desc = "LSP: Diagnostics loclist", unpack(bufopts) })

      vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename", unpack(bufopts) })
      vim.keymap.set("n", p .. "rn", vim.lsp.buf.rename, { desc = "LSP: Rename", unpack(bufopts) })
      vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { desc = "LSP: Code actions", unpack(bufopts) })
      vim.keymap.set("n", p .. "a", vim.lsp.buf.code_action, { desc = "LSP: Code actions", unpack(bufopts) })

      vim.keymap.set("n", p .. "f", function()
         vim.lsp.buf.format({ async = true })
      end, { desc = "LSP: Format", unpack(bufopts) })

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
end

M.on_attach = build_on_attach()
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
