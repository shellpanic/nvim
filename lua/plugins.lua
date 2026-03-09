require("lazy").setup({
   -- Core/UI
   require("plugins.lualine"),
   require("plugins.which-key"),
   require("plugins.smoji"),
   require("plugins.icons"),
   require("plugins.devcontainer"),

   -- Editing
   require("plugins.surround"),
   require("plugins.neo-tree"),
   require("plugins.comment"),
   require("plugins.autopairs"),
   require("plugins.indent"),
   require("plugins.toggleterm"),
   require("plugins.telescope"),
   require("plugins.neo-clip"),
   require("plugins.color-picker"),
   require("plugins.aerial"),

   -- Theme
   require("plugins.rigel"),

   -- Language Features
   require("plugins.mason"),
   require("plugins.lsp"),
   require("plugins.cmp"),
   require("plugins.treesitter"),
   require("plugins.flutter-tools"),

   -- Linting and Formatting
   require("plugins.linter"),
   require("plugins.conform"),

   -- Debugging
   require("plugins.dap"),
   require("plugins.rustacean"),

   -- Testing
   require("plugins.neotest"),

   -- Markdown
   require("plugins.render-markdown"),
   require("plugins.peek"),

   -- AI
   require("plugins.copilot-chat"),
   require("plugins.codex"),
})
