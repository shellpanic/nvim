return {
   "https://github.com/esensar/nvim-dev-container",
   lazy = false,
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      nvim_install_as_root = false,
      log_level = "info",
      cache_images = true,
      attach_mounts = {
         neovim_config = { enabled = true },
         neovim_data = { enabled = true },
         neovim_state = { enabled = true },
      },
   },
}
