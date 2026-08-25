local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- Basic setup
require("settings")
require("plugins")
require("keymap")

-- Domain keymaps (side-effect modules)
require("plugins.ui.keymaps")
require("plugins.editor.keymaps")
require("plugins.lsp.keymaps")
require("plugins.dap.keymaps")
require("plugins.testing.keymaps")
require("plugins.ai.keymaps")
require("plugins.markdown.keymaps")
require("plugins.misc.keymaps")
