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
                     -- Avoid duplicate function entries by disabling RA's snippet variants
                     completion = { callSnippet = "Disable" },
                  },
               },
               on_attach = function(_, bufnr)
                  local bufopts = { noremap = true, silent = true, buffer = bufnr }
                  local p = "<leader>l"
                  -- Standard LSP
                  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Declaration", unpack(bufopts) })
                  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Definition", unpack(bufopts) })
                  vim.keymap.set("n", p .. "h", vim.lsp.buf.hover, { desc = "LSP: Hover", unpack(bufopts) })
                  vim.keymap.set(
                     "n",
                     "gi",
                     vim.lsp.buf.implementation,
                     { desc = "LSP: Implementation", unpack(bufopts) }
                  )
                  vim.keymap.set(
                     "n",
                     p .. "K",
                     vim.lsp.buf.signature_help,
                     { desc = "LSP: Signature help", unpack(bufopts) }
                  )
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
                  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename", unpack(bufopts) })
                  vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { desc = "LSP: Code actions", unpack(bufopts) })
                  vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: References", unpack(bufopts) })
                  vim.keymap.set("n", p .. "f", function()
                     vim.lsp.buf.format({ async = true })
                  end, { desc = "LSP: Format", unpack(bufopts) })
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
                  -- Rust-specific (under <leader>lr...)
                  vim.keymap.set("n", p .. "rd", function()
                     vim.cmd.RustLsp("debuggables")
                  end, { desc = "Rust: Debuggables", unpack(bufopts) })
                  vim.keymap.set("n", p .. "rt", function()
                     vim.cmd.RustLsp("testables")
                  end, { desc = "Rust: Testables", unpack(bufopts) })
                  vim.keymap.set("n", p .. "ri", function()
                     vim.cmd.RustLsp("renderDiagnostic")
                  end, { desc = "Rust: Render diagnostic", unpack(bufopts) })
                  vim.keymap.set("n", p .. "re", function()
                     vim.cmd.RustLsp("explainError")
                  end, { desc = "Rust: Explain error", unpack(bufopts) })
                  vim.keymap.set("n", p .. "ra", function()
                     vim.cmd.RustLsp("codeAction")
                  end, { desc = "Rust: Code action", unpack(bufopts) })
                  vim.keymap.set("n", p .. "rl", function()
                     vim.cmd.RustLsp("joinLines")
                  end, { desc = "Rust: Join lines", unpack(bufopts) })
                  vim.keymap.set("n", p .. "rs", function()
                     vim.cmd.RustLsp("syntaxTree")
                  end, { desc = "Rust: Syntax tree", unpack(bufopts) })
                  vim.keymap.set("n", p .. "rg", function()
                     vim.cmd.RustLsp({ "crateGraph", "[backend]", "[output]" })
                  end, { desc = "Rust: Crate graph", unpack(bufopts) })
                  vim.keymap.set("n", p .. "rf", function()
                     vim.cmd.RustLsp({ "flyCheck" })
                  end, { desc = "Rust: Fly check", unpack(bufopts) })
               end,
            },
         }
         conf.dap = { adapter = detect_adapter }
         return conf
      end
   end,
}
