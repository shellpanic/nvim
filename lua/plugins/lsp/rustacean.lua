return {
   "mrcjkb/rustaceanvim",
   version = "^9",
   -- Rustaceanvim is a filetype plugin and performs its own lazy initialization.
   lazy = false,
   init = function()
      vim.g.rustaceanvim = function()
         local common = require("plugins.lsp.common")

         return {
            server = {
               default_settings = {
                  ["rust-analyzer"] = {
                     -- Avoid duplicate function entries from rust-analyzer snippet variants.
                     completion = { callSnippet = "Disable" },
                  },
               },
               on_attach = function(client, bufnr)
                  common.on_attach(client, bufnr)

                  local function map(suffix, command, desc)
                     vim.keymap.set("n", "<leader>lR" .. suffix, function()
                        vim.cmd.RustLsp(command)
                     end, { buffer = bufnr, silent = true, desc = desc })
                  end

                  map("d", "debuggables", "Rust: Debuggables")
                  map("t", "testables", "Rust: Testables")
                  map("i", "renderDiagnostic", "Rust: Render diagnostic")
                  map("e", "explainError", "Rust: Explain error")
                  map("a", "codeAction", "Rust: Code action")
                  map("l", "joinLines", "Rust: Join lines")
                  map("s", "syntaxTree", "Rust: Syntax tree")
                  map("g", "crateGraph", "Rust: Crate graph")
                  map("f", "flyCheck", "Rust: Fly check")
               end,
            },
         }
      end
   end,
}
