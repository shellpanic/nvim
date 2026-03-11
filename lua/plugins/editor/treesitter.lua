return {
   {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs",
      opts = {
         ensure_installed = {
            "bash",
            "lua",
            "python",
            "rust",
            "html",
            "vue",
            "json",
            "jsonc",
            "yaml",
            "markdown",
            "typescript",
            "javascript",
            "diff",
         },
         sync_install = false,
         auto_install = false,
         ignore_install = {},
         highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = false },
         modules = {},
      },
      init = function()
         -- Folding powered by Treesitter
         vim.opt.foldenable = false
         vim.opt.foldmethod = "expr"
         vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
         pcall(function()
            vim.treesitter.language.register("bash", "zsh")
         end)
      end,
   },
   {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
   },
}
