return {
   "mrcjkb/rustaceanvim",
   version = "^4",
   ft = { "rust" },
   dependencies = {},
   init = function()
      vim.g.rustaceanvim = function()
         local function detect_adapter()
            if vim.fn.executable("codelldb") == 1 then
               return {
                  type = "server",
                  host = "127.0.0.1",
                  port = "${port}",
                  executable = { command = "codelldb", args = { "--port", "${port}" } },
               }
            end
            local has_dap = vim.fn.executable("lldb-dap") == 1
            local has_vscode = vim.fn.executable("lldb-vscode") == 1
            if has_dap or has_vscode then
               return { type = "executable", command = has_dap and "lldb-dap" or "lldb-vscode", name = "lldb" }
            end
            return false
         end

         local conf = {
            server = {
               settings = {
                  ["rust-analyzer"] = {
                     completion = { callSnippet = "AddArguments" },
                  },
               },
               on_attach = function(_, bufnr)
                  local bufopts = { noremap = true, silent = true, buffer = bufnr }
                  local p = "<leader>l"
                  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                  vim.keymap.set("n", p .. "h", vim.lsp.buf.hover, bufopts)
                  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                  vim.keymap.set("n", p .. "K", vim.lsp.buf.signature_help, bufopts)
                  vim.keymap.set("n", p .. "wa", vim.lsp.buf.add_workspace_folder, bufopts)
                  vim.keymap.set("n", p .. "wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                  vim.keymap.set("n", p .. "wl", function()
                     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end, bufopts)
                  vim.keymap.set("n", p .. "t", vim.lsp.buf.type_definition, bufopts)
                  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
                  vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, bufopts)
                  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                  vim.keymap.set("n", p .. "f", function()
                     vim.lsp.buf.format({ async = true })
                  end, bufopts)
                  vim.keymap.set("n", p .. "e", vim.diagnostic.open_float, bufopts)
                  vim.keymap.set("n", p .. "q", vim.diagnostic.setloclist, bufopts)
                  vim.keymap.set("n", p .. "rd", function()
                     vim.cmd.RustLsp("debuggables")
                  end, bufopts)
                  vim.keymap.set("n", p .. "rt", function()
                     vim.cmd.RustLsp("testables")
                  end, bufopts)
                  vim.keymap.set("n", p .. "ri", function()
                     vim.cmd.RustLsp("renderDiagnostic")
                  end, bufopts)
                  vim.keymap.set("n", p .. "re", function()
                     vim.cmd.RustLsp("explainError")
                  end, bufopts)
                  vim.keymap.set("n", p .. "ra", function()
                     vim.cmd.RustLsp("codeAction")
                  end, bufopts)
                  vim.keymap.set("n", p .. "rl", function()
                     vim.cmd.RustLsp("joinLines")
                  end, bufopts)
                  vim.keymap.set("n", p .. "rs", function()
                     vim.cmd.RustLsp("syntaxTree")
                  end, bufopts)
                  vim.keymap.set("n", p .. "rg", function()
                     vim.cmd.RustLsp({ "crateGraph", "[backend]", "[output]" })
                  end, bufopts)
                  vim.keymap.set("n", p .. "rf", function()
                     vim.cmd.RustLsp({ "flyCheck" })
                  end, bufopts)
               end,
            },
         }
         conf.dap = { adapter = detect_adapter }
         return conf
      end
   end,
}
