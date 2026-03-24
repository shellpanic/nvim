-- LSP domain keymaps
-- no return; this module is for side-effect keymaps only

-- Label nested Rust group under LSP for which-key
pcall(function()
   require("which-key").add({ { "<leader>lr", group = "Rust" } })
end)

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
   if type(ih) == "table" then
      local bufnr = vim.api.nvim_get_current_buf()
      local enabled = false
      if ih.is_enabled then
         enabled = ih.is_enabled(bufnr)
         ih.enable(bufnr, not enabled)
      elseif ih.get then
         enabled = ih.get(bufnr)
         ih(bufnr, not enabled)
      else
         ih(bufnr, not enabled)
      end
   end
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
