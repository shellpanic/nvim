require("lazy").setup({
   -- Basic Tooling
   require("plugins.lualine"),
   {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
         require("plug-config.surround")
      end,
   },
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
         "MunifTanjim/nui.nvim",
      },
      config = function()
         require("plug-config.neo-tree")
      end,
   },
   {
      "terrortylor/nvim-comment",
      config = function()
         require("plug-config.comment")
      end,
   },
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
   {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
         require("plug-config.toggleterm")
      end,
   },
   {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         require("plug-config.telescope")
      end,
   },
   {
      "AckslD/nvim-neoclip.lua",
      dependencies = {
         { "nvim-telescope/telescope.nvim" },
      },
      config = function()
         require("plug-config.neo-clip")
      end,
   },
   require("plugins.which-key"),
   require("plugins.smoji"),
   require("plugins.icons"),
   require("plugins.devcontainer"),

   -- Markdown Tooling
   require("plugins.render-markdown"), -- before cmp since it integrates in it
   {
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
         require("plug-config.markdown")
      end,
   },

   -- Style
   {
      "Rigellute/rigel",
      priority = 1000,
      config = function()
         require("plug-config.rigel")
      end,
   },
   {
      "ziontee113/color-picker.nvim",
      config = function()
         require("plug-config.color-picker")
      end,
   },

   -- Language Features
   {
      "williamboman/mason.nvim",
      dependencies = {
         "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
      config = function()
         require("plug-config.mason")
      end,
   },
   "williamboman/mason-lspconfig.nvim",

   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "folke/neodev.nvim",
         "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
         require("plug-config.neodev")
         require("plug-config.lsp")
      end,
   },
   "hrsh7th/cmp-nvim-lsp",
   "hrsh7th/cmp-buffer",
   "hrsh7th/cmp-path",
   "hrsh7th/cmp-cmdline",
   {
      "hrsh7th/nvim-cmp",
      config = function()
         require("plug-config.cmp")
      end,
   },
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

   { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
   "nvim-treesitter/nvim-treesitter-textobjects",
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("plug-config.treesitter")
      end,
   },
   "nvim-treesitter/nvim-treesitter-textobjects",

   require("plugins.flutter-tools"),

   -- Linting and Formatting
   {
      "mfussenegger/nvim-lint",
      event = {
         "BufReadPre",
         "BufNewFile",
      },
      config = function()
         require("plug-config.linter")
      end,
   },
   {
      "stevearc/conform.nvim",
      event = {
         "BufReadPre",
         "BufNewFile",
      },
      config = function()
         require("plug-config.conform")
      end,
   },

   -- Debugging
   {
      "stevearc/aerial.nvim",
      config = function()
         require("plug-config.aerial")
      end,
   },
   {
      "mfussenegger/nvim-dap",
      dependencies = { "rcarriga/nvim-dap-ui" },
      config = function()
         require("plug-config.dap")
      end,
   },
   { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
   {
      "mfussenegger/nvim-dap-python",
      dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
   },
   {
      "mrcjkb/rustaceanvim",
      version = "^4", -- Recommended
      ft = { "rust" },
      dependencies = {
         {
            "zbirenbaum/copilot-cmp",
            config = function()
               require("copilot_cmp").setup()
            end,
         },
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
      config = function()
         require("plug-config.neotest")
      end,
   },

   -- AI
   require("plugins.copilot-chat"),
   require("plugins.codex"),
})
