return {
   "windwp/nvim-autopairs",
   event = "InsertEnter",
   config = function()
      require("nvim-autopairs").setup()

      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local handler = cmp_autopairs.on_confirm_done()
      cmp.event:on("confirm_done", function(event)
         local item = event.entry:get_completion_item()
         if item and item.insertTextFormat == 2 then
            -- The LSP snippet already owns its placeholders and parentheses.
            return
         end
         handler(event)
      end)
   end,
}
