return require("lazy").setup({
   -- UI and Theme
   require("plugins.ui.rigel"),
   require("plugins.ui.icons"),
   require("plugins.ui.devicons"),
   require("plugins.ui.dressing"),
   require("plugins.ui.indent"),
   require("plugins.ui.lualine"),
   require("plugins.ui.neo-tree"),

   -- Editor
   require("plugins.editor.which-key"),
   require("plugins.editor.comment"),
   require("plugins.editor.autopairs"),
   require("plugins.editor.telescope"),
   require("plugins.editor.aerial"),
   require("plugins.editor.neo-clip"),
   require("plugins.editor.toggleterm"),
   require("plugins.editor.treesitter"),
   require("plugins.editor.linter"),
   require("plugins.editor.conform"),
   require("plugins.editor.cmp"),

   -- Markdown
   require("plugins.markdown.render-markdown"),
   require("plugins.markdown.peek"),

   -- LSP
   require("plugins.lsp.mason"),
   require("plugins.lsp.lsp"),
   require("plugins.lsp.flutter-tools"),
   require("plugins.lsp.rustacean"),
   require("plugins.lsp.crates"),

   -- DAP
   require("plugins.dap.dap"),

   -- Testing
   require("plugins.testing.neotest"),

   -- AI
   require("plugins.ai.codex"),

   -- Misc
   require("plugins.misc.devcontainer"),
   require("plugins.misc.smoji"),
})
