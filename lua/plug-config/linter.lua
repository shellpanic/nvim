local lint = require("lint")
local linters = require("lint").linters

lint.linters_by_ft = {
   -- lua = { "selene" }, -- results in issues, same with "selene"
   python = { "flake8" },
   markdown = { "markdownlint" },
   rust = { "ast-grep" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
   group = lint_augroup,
   callback = function()
      lint.try_lint()
      --
      -- You can call `try_lint` with a linter name or a list of names to always
      -- run specific linters, independent of the `linters_by_ft` configuration
      -- lint.try_lint("cspell")
   end,
})
