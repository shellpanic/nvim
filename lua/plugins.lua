local loader = require("plugins._loader")

local specs = loader.collect({
   "plugins/ui",
   "plugins/editor",
   "plugins/markdown",
   "plugins/lsp",
   "plugins/dap",
   "plugins/testing",
   "plugins/ai",
   "plugins/misc",
})

return require("lazy").setup(specs)
