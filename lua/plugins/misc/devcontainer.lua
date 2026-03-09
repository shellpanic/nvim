return {
   "https://github.com/esensar/nvim-dev-container",
   -- Load on demand to avoid side effects during healthcheck/startup
   lazy = true,
   cmd = {
      "DevcontainerBuild",
      "DevcontainerOpen",
      "DevcontainerAttach",
      "DevcontainerClean",
   },
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      nvim_install_as_root = false,
      -- keep logs quieter to reduce writes in constrained environments
      log_level = "warn",
      cache_images = true,
      attach_mounts = {
         neovim_config = { enabled = true },
         neovim_data = { enabled = true },
         neovim_state = { enabled = true },
      },
   },
}
