local conform = require("conform")

conform.setup({
   -- Map of filetype to formatters
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
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace" },
   },
   -- If this is set, Conform will run the formatter on save.
   -- It will pass the table to conform.format().
   -- This can also be a function that returns the table.
   format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
   },
   -- If this is set, Conform will run the formatter asynchronously after save.
   -- It will pass the table to conform.format().
   -- This can also be a function that returns the table.
   format_after_save = {
      lsp_fallback = true,
   },

   -- Set the log level. Use `:ConformInfo` to see the location of the log file.
   log_level = vim.log.levels.ERROR,
   -- Conform will notify you when a formatter errors
   notify_on_error = true,
})

conform.formatters.stylua = {}
