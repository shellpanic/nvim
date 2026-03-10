local vim = vim
local opt = vim.opt

vim.g.mapleader = "-"

-- Disable unused providers to silence health warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Filetype tweaks
vim.filetype.add({
   extension = { mdx = "markdown.mdx" },
})

-- Minimal health command to skip deprecated checks
pcall(function()
   vim.api.nvim_create_user_command("HealthMinimal", function()
      vim.cmd([[
        checkhealth lazy
        checkhealth vim.lsp
        checkhealth nvim-treesitter
        checkhealth mason
        checkhealth vim.provider
        checkhealth dressing
        checkhealth telescope
        checkhealth dap
      ]])
   end, { desc = "Run focused health checks only" })
end)

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
