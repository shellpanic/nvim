-- Markdown domain keymaps
-- no return; this module is for side-effect keymaps only

local group = vim.api.nvim_create_augroup("markdown_keymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
   group = group,
   pattern = { "markdown", "markdown.mdx" },
   callback = function(event)
      vim.keymap.set("n", "?", "<cmd>WhichKeyBuffer<CR>", {
         buffer = event.buf,
         silent = true,
         desc = "Markdown: Show buffer keymaps",
      })

      vim.keymap.set("n", "<Leader>cd", function()
         if vim.fn.executable("termaid") == 0 then
            vim.notify("Mermaid preview requires termaid: uv tool install termaid", vim.log.levels.ERROR)
            return
         end
         vim.cmd("MermaidFloat")
      end, { buffer = event.buf, silent = true, desc = "Code: Preview Mermaid diagram" })
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   group = group,
   pattern = "mermaid-preview",
   callback = function(event)
      local wk = require("which-key")

      vim.keymap.set("n", "?", function()
         wk.show({ global = false })
      end, {
         buffer = event.buf,
         silent = true,
         desc = "Mermaid: Show preview keymaps",
      })

      -- mermaid-nvim's preview mappings do not include descriptions, so add
      -- buffer-local which-key metadata for the help popup.
      wk.add({
         {
            mode = "n",
            buffer = event.buf,
            { "?", desc = "Show preview keymaps" },
            { "<Left>", desc = "Pan left" },
            { "<Right>", desc = "Pan right" },
            { "<Up>", desc = "Pan up" },
            { "<Down>", desc = "Pan down" },
            { "H", desc = "Jump to left edge" },
            { "L", desc = "Jump to right edge" },
            { "0", desc = "Reset horizontal scroll" },
            { "c", desc = "Center diagram" },
            { "t", desc = "Center diagram at top" },
            { "s", desc = "Toggle shortened labels" },
            { "h", desc = "Toggle label hints" },
            { "q", desc = "Close preview" },
            { "<Esc>", desc = "Close preview" },
         },
      })
   end,
})
