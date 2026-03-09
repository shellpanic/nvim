return {
   "Rigellute/rigel",
   priority = 1000,
   lazy = false,
   config = function()
      vim.o.termguicolors = true
      vim.cmd.colorscheme("rigel")
   end,
}
