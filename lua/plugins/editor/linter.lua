return {
   "mfussenegger/nvim-lint",
   ft = { "markdown", "markdown.mdx", "yaml" },
   cmd = { "LintTry" },
   config = function()
      local devtools = require("devtools")
      local lint = require("lint")
      lint.linters_by_ft = {
         markdown = { "markdownlint" },
         ["markdown.mdx"] = { "markdownlint" },
         yaml = { "yamllint" },
      }

      local markdownlint = require("lint.linters.markdownlint")
      lint.linters.markdownlint = function()
         local linter = vim.deepcopy(markdownlint)
         local config = devtools.find_project_config("markdownlint", vim.api.nvim_buf_get_name(0))
            or devtools.existing_path("markdownlint.yaml")
         linter.args = { "--stdin" }
         if config then
            vim.list_extend(linter.args, { "--config", config })
         end
         return linter
      end

      local yamllint = require("lint.linters.yamllint")
      lint.linters.yamllint = function()
         local linter = vim.deepcopy(yamllint)
         local config = devtools.find_project_config("yamllint", vim.api.nvim_buf_get_name(0))
            or devtools.existing_path("yamllint.yaml")
         linter.args = { "--format", "parsable" }
         if config then
            vim.list_extend(linter.args, { "--config-file", config })
         end
         table.insert(linter.args, "-")
         return linter
      end

      local function available_linters()
         local configured = lint.linters_by_ft[vim.bo.filetype] or {}
         local available = {}
         for _, name in ipairs(configured) do
            local linter = lint.linters[name]
            if type(linter) == "function" then
               linter = linter()
            end
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
