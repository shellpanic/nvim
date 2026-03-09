return {
   "nvim-neotest/neotest",
   dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   keys = {
      {
         "<Leader>iwf",
         function()
            require("neotest").watch.toggle(vim.fn.expand("%"))
         end,
         desc = "Toggle file watch",
      },
      {
         "<Leader>is",
         function()
            require("neotest").summary.toggle()
         end,
         desc = "Toggle test summary",
      },
      {
         "<Leader>isn",
         function()
            require("neotest").run.stop()
         end,
         desc = "Stop tests",
      },
      {
         "<Leader>iw",
         function()
            require("neotest").watch.toggle()
         end,
         desc = "Toggle watch",
      },
      {
         "<Leader>ir",
         function()
            require("neotest").run.run()
         end,
         desc = "Run tests",
      },
      {
         "<Leader>io",
         function()
            require("neotest").output.open({ enter = true })
         end,
         desc = "Open test output",
      },
      {
         "<Leader>ios",
         function()
            require("neotest").output.open({ short = true, enter = true })
         end,
         desc = "Open short output",
      },
      {
         "<Leader>iop",
         function()
            require("neotest").output_panel.toggle()
         end,
         desc = "Toggle output panel",
      },
      {
         "<Leader>ioc",
         function()
            require("neotest").output_panel.clear()
         end,
         desc = "Clear output panel",
      },
      {
         "<Leader>irf",
         function()
            require("neotest").run.run(vim.fn.expand("%"))
         end,
         desc = "Run file tests",
      },
      {
         "<Leader>id",
         function()
            require("neotest").run.run({ strategy = "dap" })
         end,
         desc = "Run with DAP",
      },
      {
         "<Leader>idf",
         function()
            require("neotest").run.run(vim.fn.expand("%"), { strategy = "dap" })
         end,
         desc = "Run file with DAP",
      },
      {
         "<Leader>ia",
         function()
            require("neotest").run.attach()
         end,
         desc = "Attach to test",
      },
   },
   config = function()
      local adapters = {}
      local ok_rust, rust_adapter = pcall(require, "rustaceanvim.neotest")
      if ok_rust and rust_adapter then
         table.insert(adapters, rust_adapter)
      end
      local ok_py, neotest_python = pcall(require, "neotest-python")
      if ok_py and neotest_python then
         table.insert(adapters, neotest_python({ dap = { justMyCode = false } }))
      end
      require("neotest").setup({
         adapters = adapters,
         discovery = { enabled = false, concurrent = 0 },
         running = { concurrent = true },
         summary = { animated = true },
      })
   end,
}
