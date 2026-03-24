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
               -- LSP (ensure these explicit languages are present; nothing auto-installs otherwise)
               "lua-language-server",
               "typescript-language-server",
               "yaml-language-server",
               "marksman",
               "basedpyright",
               "ruff",
               "taplo", -- TOML LSP
               "bash-language-server",
               "dockerfile-language-server",
               "vue-language-server",
               "rust-analyzer",

               -- DAP
               "codelldb",
               "debugpy",
               -- Linters
               "flake8",
               "pyproject-flake8",
               "eslint_d",
               "markdownlint",
               "yamllint",
               "selene",
               -- Formatters & tools
               "prettier",
               "stylua",
               "beautysh",
               "shfmt",
               "isort",
               "black",
               "yamlfmt",
            },
         })
      end,
   },
   { "williamboman/mason-lspconfig.nvim" },
}
