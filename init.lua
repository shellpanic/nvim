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
pcall(require, "plugins.ui.keymaps")
pcall(require, "plugins.editor.keymaps")
pcall(require, "plugins.dap.keymaps")
pcall(require, "plugins.testing.keymaps")
pcall(require, "plugins.ai.keymaps")
pcall(require, "plugins.markdown.keymaps")
pcall(require, "plugins.misc.keymaps")
