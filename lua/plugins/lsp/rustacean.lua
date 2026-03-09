return {
   "mrcjkb/rustaceanvim",
   version = "^4",
   ft = { "rust" },
   dependencies = {
      {
         "zbirenbaum/copilot-cmp",
         config = function()
            require("copilot_cmp").setup()
         end,
      },
   },
   init = function()
      vim.g.rustaceanvim = function()
         return {
            server = {
               on_attach = function(_, bufnr)
                  local bufopts = { noremap = true, silent = true, buffer = bufnr }
                  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                  vim.keymap.set("n", "C-S-o", vim.lsp.buf.hover, bufopts)
                  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                  vim.keymap.set("n", "<C-p>", vim.lsp.buf.signature_help, bufopts)
                  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                  vim.keymap.set("n", "<space>wl", function()
                     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end, bufopts)
                  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
                  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
                  vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, bufopts)
                  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                  vim.keymap.set("n", "<space>f", function()
                     vim.lsp.buf.format({ async = true })
                  end, bufopts)
                  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
                  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, bufopts)
                  vim.keymap.set("n", "<space>rd", function()
                     vim.cmd.RustLsp("debuggables")
                  end, bufopts)
                  vim.keymap.set("n", "<space>rt", function()
                     vim.cmd.RustLsp("testables")
                  end, bufopts)
                  vim.keymap.set("n", "<space>ri", function()
                     vim.cmd.RustLsp("renderDiagnostic")
                  end, bufopts)
                  vim.keymap.set("n", "<space>re", function()
                     vim.cmd.RustLsp("explainError")
                  end, bufopts)
                  vim.keymap.set("n", "<space>ra", function()
                     vim.cmd.RustLsp("codeAction")
                  end, bufopts)
                  vim.keymap.set("n", "<space>rl", function()
                     vim.cmd.RustLsp("joinLines")
                  end, bufopts)
                  vim.keymap.set("n", "<space>rt", function()
                     vim.cmd.RustLsp("syntaxTree")
                  end, bufopts)
                  vim.keymap.set("n", "<space>rg", function()
                     vim.cmd.RustLsp({ "crateGraph", "[backend]", "[output]" })
                  end, bufopts)
                  vim.keymap.set("n", "<space>rf", function()
                     vim.cmd.RustLsp({ "flyCheck" })
                  end, bufopts)
               end,
            },
         }
      end
   end,
}
