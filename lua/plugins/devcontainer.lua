return {
   "https://codeberg.org/esensar/nvim-dev-container",
   lazy = false,
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      nvim_install_as_root = false,
      log_level = "info",
      -- can be set to false to disable image caching when adding neovim
      -- by default it is set to true to make attaching to containers faster after first time
      cache_images = true,
      -- Default-Mounts des Plugins abschalten (zielen auf /root/…)
      attach_mounts = {
         neovim_config = { enabled = true },
         neovim_data = { enabled = true },
         neovim_state = { enabled = true },
      },
   },
}
