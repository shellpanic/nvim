require("lazy").setup({
   -- Basic Tooling
   require("plugins.lualine"),
   {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
   },
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
         "MunifTanjim/nui.nvim",
      },
   },
   "terrortylor/nvim-comment",
   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
   },
   {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
      config = function()
         require("ibl").setup()
      end,
   },
   { "akinsho/toggleterm.nvim", version = "*", config = true },
   {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
   },
   {
      "AckslD/nvim-neoclip.lua",
      dependencies = {
         { "nvim-telescope/telescope.nvim" },
      },
   },
   require("plugins.which-key"),
   require("plugins.smoji"),

   -- Markdown Tooling
   require("plugins.render-markdown"), -- before cmp since it integrates in it
   {
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
         require("peek").setup()
         vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
         vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
   },

   -- Style
   "Rigellute/rigel",
   "ziontee113/color-picker.nvim",

   -- Language Features
   {
      "williamboman/mason.nvim",
      dependencies = {
         "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
   },
   "williamboman/mason-lspconfig.nvim",

   "neovim/nvim-lspconfig",
   "hrsh7th/cmp-nvim-lsp",
   "hrsh7th/cmp-buffer",
   "hrsh7th/cmp-path",
   "hrsh7th/cmp-cmdline",
   "hrsh7th/nvim-cmp",
   "onsails/lspkind.nvim",
   {
      "linrongbin16/lsp-progress.nvim",
      config = function()
         require("lsp-progress").setup()
      end,
   },
   {
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {},
      config = function(_, opts)
         require("lsp_signature").setup(opts)
      end,
   },

   {
      "L3MON4D3/LuaSnip",
      lazy = false,
      build = "make install_jsregexp",
   },
   "saadparwaiz1/cmp_luasnip",
   "rafamadriz/friendly-snippets",

   { "folke/neodev.nvim", opts = {} },

   { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
   "nvim-treesitter/nvim-treesitter-textobjects",

   require("plugins.flutter-tools"),

   -- Linting and Formatting
   {
      "mfussenegger/nvim-lint",
      event = {
         "BufReadPre",
         "BufNewFile",
      },
   },
   {
      "stevearc/conform.nvim",
      event = {
         "BufReadPre",
         "BufNewFile",
      },
   },

   -- Debugging
   "stevearc/aerial.nvim",
   "mfussenegger/nvim-dap",
   { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
   {
      "mfussenegger/nvim-dap-python",
      dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
      config = function(_, opts)
         local path = "/home/fla/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
         require("dap-python").setup(path)
      end,
   },
   {
      "mrcjkb/rustaceanvim",
      version = "^4", -- Recommended
      ft = { "rust" },
      {
         "zbirenbaum/copilot-cmp",
         config = function()
            require("copilot_cmp").setup()
         end,
      },
   },

   -- Test Framework
   {
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-neotest/nvim-nio",
         "nvim-lua/plenary.nvim",
         "nvim-neotest/neotest-python",
         "antoinemadec/FixCursorHold.nvim",
         "nvim-treesitter/nvim-treesitter",
      },
   },

   -- AI
   require("plugins.copilot-chat"),
   require("plugins.codex"),
})

-- Source configurations
require("plug-config.rigel")
require("plug-config.neo-tree")
require("plug-config.comment")
require("plug-config.surround")
require("plug-config.color-picker")
require("plug-config.telescope")
require("plug-config.toggleterm")
require("plug-config.neo-clip")

require("plug-config.mason")
require("plug-config.cmp")
require("plug-config.lsp")
require("plug-config.treesitter")
require("plug-config.neodev")
require("plug-config.aerial")

require("plug-config.conform")
require("plug-config.linter")
require("plug-config.markdown")

require("plug-config.dap")
require("plug-config.rustacean")
require("plug-config.neotest")
