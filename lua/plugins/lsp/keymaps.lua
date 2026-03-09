-- LSP domain keymaps
-- no return; this module is for side-effect keymaps only

-- Toggle LSP signature help window
vim.keymap.set("n", "<Leader>ls", function()
   local ok, lsp_signature = pcall(require, "lsp_signature")
   if ok then
      lsp_signature.toggle_float_win()
   end
end, { silent = true, desc = "Toggle LSP signature window" })
