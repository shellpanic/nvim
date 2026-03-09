return {
   "mfussenegger/nvim-lint",
   event = { "BufReadPre", "BufNewFile" },
   cmd = { "LintTry" },
   config = function()
      pcall(function()
         vim.api.nvim_create_user_command("LintTry", function()
            require("lint").try_lint()
         end, {})
      end)
   end,
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
