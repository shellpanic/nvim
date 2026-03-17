return {
   "mfussenegger/nvim-lint",
   event = { "BufReadPre", "BufNewFile" },
   cmd = { "LintTry" },
   config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
         python = { "ruff" },
         markdown = { "markdownlint" },
         yaml = { "yamllint" },
         rust = { "ast-grep" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
         group = lint_augroup,
         callback = function()
            require("lint").try_lint()
         end,
      })
      pcall(function()
         vim.api.nvim_create_user_command("LintTry", function()
            require("lint").try_lint()
         end, {})
      end)
   end,
}
