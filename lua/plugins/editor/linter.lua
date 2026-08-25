return {
   "mfussenegger/nvim-lint",
   event = { "BufReadPre", "BufNewFile" },
   cmd = { "LintTry" },
   config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
         python = { "ruff" },
         markdown = { "markdownlint" },
         ["markdown.mdx"] = { "markdownlint" },
         yaml = { "yamllint" },
      }

      local function available_linters()
         local configured = lint.linters_by_ft[vim.bo.filetype] or {}
         local available = {}
         for _, name in ipairs(configured) do
            local linter = lint.linters[name]
            local cmd = linter and linter.cmd
            if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
               table.insert(available, name)
            elseif type(cmd) == "table" and #cmd > 0 and vim.fn.executable(cmd[1]) == 1 then
               table.insert(available, name)
            end
         end
         return available
      end

      local function try_lint(notify_if_empty)
         local available = available_linters()
         if #available > 0 then
            lint.try_lint(available)
         elseif notify_if_empty then
            vim.notify("No available linters for filetype: " .. vim.bo.filetype, vim.log.levels.INFO)
         end
      end

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
         group = lint_augroup,
         callback = function()
            try_lint(false)
         end,
      })

      vim.api.nvim_create_user_command("LintTry", function()
         try_lint(true)
      end, {})
   end,
}
