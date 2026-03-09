return {
   "stevearc/conform.nvim",
   event = { "BufReadPre", "BufNewFile" },
   cmd = { "ConformFormat" },
   config = function()
      local conform = require("conform")
      conform.setup({
         formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            python = { "isort", "black" },
            lua = { "stylua" },
            toml = { "taplo" },
            rust = { "rustfmt" },
            dart = { "dcm" },
            bash = { "shfmt" },
            sh = { "shfmt" },
            zsh = { "beautysh" },
            yaml = { "yamlfmt" },
            vue = { "prettier" },
            ["_"] = { "trim_whitespace" },
         },
         format_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
         format_after_save = { lsp_fallback = true },
         log_level = vim.log.levels.ERROR,
         notify_on_error = true,
      })
      conform.formatters.stylua = {}
      vim.api.nvim_create_user_command("ConformFormat", function(opts)
         local range = nil
         if opts.range ~= 0 then
            range = { start = opts.line1, finish = opts.line2 }
         end
         conform.format({ lsp_fallback = true, async = false, timeout_ms = 500, range = range })
      end, { range = true })
   end,
}
