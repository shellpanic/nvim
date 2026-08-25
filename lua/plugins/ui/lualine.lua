return {
   "nvim-lualine/lualine.nvim",
   lazy = false,
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local lint_progress = function()
         local lint = package.loaded["lint"]
         if not lint then
            return ""
         end
         local linters = lint.get_running()
         if #linters == 0 then
            return "󰦕"
         end
         return "󱉶 " .. table.concat(linters, ", ")
      end

      local lsp_progress = function()
         return vim.lsp.status()
      end

      local ai_sessions = function()
         local status = package.loaded["sidekick.status"]
         if not status then
            return ""
         end
         local sessions = status.cli()
         return #sessions > 0 and (" " .. #sessions) or ""
      end

      require("lualine").setup({
         options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
               statusline = {},
               winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
               statusline = 1000,
               tabline = 1000,
               winbar = 1000,
            },
         },
         sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics", "filename" },
            lualine_c = { lint_progress, lsp_progress },
            lualine_x = { ai_sessions, "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
         },
         tabline = {},
         winbar = {},
         inactive_winbar = {},
         extensions = {},
      })

      -- Refresh the statusline when Neovim receives native LSP progress.
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("LspProgress", {
         group = "lualine_augroup",
         callback = require("lualine").refresh,
      })
   end,
}
