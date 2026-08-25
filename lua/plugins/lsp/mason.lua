return {
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
         run_on_start = true,
         start_delay = 3000,
         debounce_hours = 24,
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
            "markdownlint",
            "yamllint",
            -- Formatters & tools
            "prettier",
            "stylua",
            "beautysh",
            "shfmt",
            "isort",
            "black",
            "yamlfmt",
            "dcm",
         },
      })
   end,
}
