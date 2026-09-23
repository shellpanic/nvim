return {
   "sindrets/diffview.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" },
   opts = {
      enhanced_diff_hl = true,
      view = {
         merge_tool = { layout = "diff3_mixed" },
      },
   },
}
