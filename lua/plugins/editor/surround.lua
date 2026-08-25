return {
   "kylechui/nvim-surround",
   version = "^4.0.0",
   event = "VeryLazy",
   keys = {
      { "<C-g>s", mode = "i", desc = "Surround: Add" },
      { "<C-g>S", mode = "i", desc = "Surround: Add on new lines" },
      { "ys", mode = "n", desc = "Surround: Add around motion" },
      { "yS", mode = "n", desc = "Surround: Add around motion on new lines" },
      { "ds", mode = "n", desc = "Surround: Delete" },
      { "cs", mode = "n", desc = "Surround: Change" },
      { "cS", mode = "n", desc = "Surround: Change on new lines" },
      { "S", mode = "x", desc = "Surround: Add to selection" },
      { "gS", mode = "x", desc = "Surround: Add selection on new lines" },
   },
   opts = {},
}
