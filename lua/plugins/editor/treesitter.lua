return {
   {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      build = ":TSUpdate",
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
            "markdown_inline",
            "dockerfile",
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
      config = function(_, opts)
         local ok, configs = pcall(require, "nvim-treesitter.configs")
         if not ok then
            vim.schedule(function()
               vim.notify("nvim-treesitter not available yet; run :Lazy sync and restart", vim.log.levels.WARN)
            end)
            return
         end
         configs.setup(opts)
      end,
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
