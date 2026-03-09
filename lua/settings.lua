local vim = vim
local opt = vim.opt

vim.g.mapleader = "-"

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.tabstop = 3
opt.shiftwidth = 3
opt.softtabstop = 3
opt.smarttab = true
opt.numberwidth = 4

-- Visualize all spaces, tabs, etc.
opt.listchars = {
   tab = "󰑃 ",
   trail = "·",
   precedes = "←",
   extends = "→",
   nbsp = "␣",
   space = ".",
   -- eol = "󱞣",
}
opt.list = true

-- Folding is configured by Treesitter plugin
