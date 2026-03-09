require("mason").setup({
   ui = {
      icons = {
         package_installed = "✓",
         package_pending = "➜",
         package_uninstalled = "✗",
      },
   },
})

require("mason-tool-installer").setup({
   ensure_installed = {
      -- LSP
      "vue-language-server", --vue
      "copilot-language-server", -- github copilot integration
      --- DAP
      "codelldb", -- rust
      "debugpy", -- python
      -- Linter
      "flake8", -- python
      "pyproject-flake8", -- python
      "eslint_d", -- js
      "markdownlint", --markdown
      "selene", --lua
      "ast-grep", -- rust
      -- Formatter
      "prettier", -- a lot
      "stylua", -- lua
      "beautysh", -- zsh
      "shfmt", -- shell
      "isort", -- python
      "black", -- python
      "yamlfmt", -- yaml
      "taplo", -- toml
      "dcm", -- dart
   },
})

require("mason-lspconfig").setup({
   -- A list of servers to automatically install if they're not already installed
   ensure_installed = {
      "bashls", --bash
      "lua_ls", -- lua
      "rust_analyzer", -- rust
      "taplo",
      "ts_ls", -- typescript
      "basedpyright", --python
      "marksman", -- markdown
   },
})
