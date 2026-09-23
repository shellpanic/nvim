local external_changes = vim.api.nvim_create_augroup("external_file_changes", { clear = true })

local function check_for_external_changes()
   if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
   end
end

-- AI tools and terminal commands often update files behind Neovim's back.
-- Check loaded buffers as soon as control returns to the editor.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
   group = external_changes,
   callback = check_for_external_changes,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
   group = external_changes,
   callback = function(event)
      local path = vim.api.nvim_buf_get_name(event.buf)
      if path ~= "" then
         vim.notify("Reloaded external change: " .. vim.fn.fnamemodify(path, ":~:."), vim.log.levels.INFO)
      end
   end,
})
