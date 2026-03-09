return {
   "mfussenegger/nvim-lint",
   event = { "BufReadPre", "BufNewFile" },
   keys = {
      {
         "<C-ll>",
         function()
            local ok, lint = pcall(require, "lint")
            if ok then
               lint.try_lint()
            end
         end,
         desc = "Trigger linting for current file",
      },
   },
   config = function()
      local lint = require("lint")
      local linters = require("lint").linters
      lint.linters_by_ft = {
         python = { "flake8" },
         markdown = { "markdownlint" },
         rust = { "ast-grep" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
         group = lint_augroup,
         callback = function()
            lint.try_lint()
         end,
      })
   end,
}
