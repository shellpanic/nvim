return {
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup({
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
         })
         -- Folding powered by Treesitter
         vim.opt.foldenable = false
         vim.opt.foldmethod = "expr"
         vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
         vim.treesitter.language.register("bash", "zsh")
      end,
   },
   "nvim-treesitter/nvim-treesitter-textobjects",
}
