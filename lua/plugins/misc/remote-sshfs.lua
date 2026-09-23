return {
   "nosduco/remote-sshfs.nvim",
   cmd = {
      "RemoteSSHFSConnect",
      "RemoteSSHFSDisconnect",
      "RemoteSSHFSEdit",
      "RemoteSSHFSReload",
      "RemoteSSHFSFindFiles",
      "RemoteSSHFSLiveGrep",
   },
   dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
   },
   opts = {
      ui = {
         picker = "telescope",
      },
   },
   config = function(_, opts)
      local remote = require("remote-sshfs")
      remote.setup(opts)
      require("telescope").load_extension("remote-sshfs")

      local ssh_configs = vim.tbl_map(function(path)
         return vim.fn.fnameescape(vim.fn.expand(path))
      end, remote.config.connections.ssh_configs)

      vim.api.nvim_create_autocmd("BufWritePost", {
         group = vim.api.nvim_create_augroup("RemoteSSHFSConfigReload", { clear = true }),
         pattern = ssh_configs,
         callback = function()
            require("remote-sshfs.connections").reload()
         end,
         desc = "Reload remote SSH hosts after saving an SSH config",
      })
   end,
}
