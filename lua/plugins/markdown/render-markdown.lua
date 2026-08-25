return {
   "MeanderingProgrammer/render-markdown.nvim",
   ft = { "markdown", "markdown.mdx" },
   dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
   ---@module 'render-markdown'
   ---@type render.md.UserConfig
   opts = {
      enabled = true,
      file_types = { "markdown", "markdown.mdx" },
      latex = { enabled = false },
   },
}
