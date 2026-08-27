-- Markdown domain keymaps
-- no return; this module is for side-effect keymaps only

local group = vim.api.nvim_create_augroup("markdown_keymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
   group = group,
   pattern = { "markdown", "markdown.mdx" },
   callback = function(event)
      vim.keymap.set("n", "K", function()
         if vim.fn.executable("termaid") == 0 then
            vim.notify("Mermaid preview requires termaid: uv tool install termaid", vim.log.levels.ERROR)
            return
         end
         vim.cmd("MermaidFloat")
      end, { buffer = event.buf, silent = true, desc = "Markdown: Preview Mermaid diagram" })
   end,
})
