return {
   {
      "williamboman/mason.nvim",
      dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      config = function()
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
               "vue-language-server",
               --- DAP
               "codelldb",
               "debugpy",
               -- Linter
               "flake8",
               "pyproject-flake8",
               "eslint_d",
               "markdownlint",
               "selene",
               "ast-grep",
               -- Formatter
               "prettier",
               "stylua",
               "beautysh",
               "shfmt",
               "isort",
               "black",
               "yamlfmt",
               "taplo",
               "dcm",
            },
         })
      end,
   },
   { "williamboman/mason-lspconfig.nvim" },
}
