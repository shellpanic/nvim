return {
   "terrortylor/nvim-comment",
   config = function()
      require("nvim_comment").setup({
         comment_empty = true,
         create_mappings = false, -- avoid default gc/gcc to prevent which-key overlap warnings
      })

      -- Our own minimal mappings (no prefix overlaps)
      -- Normal/Visual: toggle line or selection
      vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", { silent = true, desc = "Comment: Toggle line" })
      vim.keymap.set("v", "<leader>/", ":CommentToggle<CR>", { silent = true, desc = "Comment: Toggle selection" })
   end,
}
