return {
   "ziontee113/color-picker.nvim",
   config = function()
      require("color-picker").setup({
         ["icons"] = { "-", "" },
         ["border"] = "rounded",
         ["keymap"] = {
            ["U"] = "<Plug>ColorPickerSlider5Decrease",
            ["O"] = "<Plug>ColorPickerSlider5Increase",
         },
         ["background_highlight_group"] = "Normal",
         ["border_highlight_group"] = "FloatBorder",
         ["text_highlight_group"] = "Normal",
      })
      vim.cmd([[hi FloatBorder guibg=NONE]])
   end,
}
