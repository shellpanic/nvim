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
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
         group = lint_augroup,
         callback = function()
            local ft = vim.bo.filetype
            local linters = lint.linters_by_ft[ft]
            if not linters or vim.tbl_isempty(linters) then
               return
            end
            local available = {}
            for _, name in ipairs(linters) do
               local l = lint.linters[name]
               local cmd = l and l.cmd
               if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
                  table.insert(available, name)
               elseif type(cmd) == "table" and #cmd > 0 and vim.fn.executable(cmd[1]) == 1 then
                  table.insert(available, name)
               end
            end
            if #available > 0 then
               lint.try_lint(available)
            end
         end,
      })
      pcall(function()
         vim.api.nvim_create_user_command("LintTry", function()
            local ft = vim.bo.filetype
            local linters = lint.linters_by_ft[ft] or {}
            local available = {}
            for _, name in ipairs(linters) do
               local l = lint.linters[name]
               local cmd = l and l.cmd
               if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
                  table.insert(available, name)
               elseif type(cmd) == "table" and #cmd > 0 and vim.fn.executable(cmd[1]) == 1 then
                  table.insert(available, name)
               end
            end
            if #available > 0 then
               lint.try_lint(available)
            else
               vim.notify("No available linters for filetype: " .. ft, vim.log.levels.INFO)
            end
         end, {})
      end)
   end,
}
