-- LSP domain keymaps
-- no return; this module is for side-effect keymaps only

-- Toggle LSP signature help window (keep as <leader>ls)
vim.keymap.set("n", "<Leader>ls", function()
   local ok, lsp_signature = pcall(require, "lsp_signature")
   if ok then
      lsp_signature.toggle_float_win()
   end
end, { silent = true, desc = "Toggle LSP signature window" })

-- Toggle inlay hints for current buffer
vim.keymap.set("n", "<Leader>li", function()
   local ih = vim.lsp.inlay_hint
   local filter = { bufnr = vim.api.nvim_get_current_buf() }
   ih.enable(not ih.is_enabled(filter), filter)
end, { silent = true, desc = "LSP: Toggle inlay hints" })

-- Toggle diagnostics virtual text
vim.keymap.set("n", "<Leader>lv", function()
   local cfg = vim.diagnostic.config()
   local vt = cfg.virtual_text
   local enabled = (vt == true) or (type(vt) == "table")
   if enabled then
      vim.diagnostic.config({ virtual_text = false })
   else
      vim.diagnostic.config({ virtual_text = { severity = { min = vim.diagnostic.severity.WARN } } })
   end
end, { silent = true, desc = "LSP: Toggle diagnostics virtual text" })
