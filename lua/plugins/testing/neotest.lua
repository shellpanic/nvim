return {
   "nvim-neotest/neotest",
   dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   cmd = {
      "NeotestWatchFileToggle",
      "NeotestSummaryToggle",
      "NeotestRunStop",
      "NeotestWatchToggle",
      "NeotestRun",
      "NeotestOutputOpen",
      "NeotestOutputOpenShort",
      "NeotestOutputPanelToggle",
      "NeotestOutputPanelClear",
      "NeotestRunFile",
      "NeotestRunDap",
      "NeotestRunFileDap",
      "NeotestAttach",
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

      -- user commands wrapping neotest actions for keymaps
      local nt = require("neotest")
      vim.api.nvim_create_user_command("NeotestWatchFileToggle", function()
         nt.watch.toggle(vim.fn.expand("%"))
      end, {})
      vim.api.nvim_create_user_command("NeotestSummaryToggle", function()
         nt.summary.toggle()
      end, {})
      vim.api.nvim_create_user_command("NeotestRunStop", function()
         nt.run.stop()
      end, {})
      vim.api.nvim_create_user_command("NeotestWatchToggle", function()
         nt.watch.toggle()
      end, {})
      vim.api.nvim_create_user_command("NeotestRun", function()
         nt.run.run()
      end, {})
      vim.api.nvim_create_user_command("NeotestOutputOpen", function()
         nt.output.open({ enter = true })
      end, {})
      vim.api.nvim_create_user_command("NeotestOutputOpenShort", function()
         nt.output.open({ short = true, enter = true })
      end, {})
      vim.api.nvim_create_user_command("NeotestOutputPanelToggle", function()
         nt.output_panel.toggle()
      end, {})
      vim.api.nvim_create_user_command("NeotestOutputPanelClear", function()
         nt.output_panel.clear()
      end, {})
      vim.api.nvim_create_user_command("NeotestRunFile", function()
         nt.run.run(vim.fn.expand("%"))
      end, {})
      vim.api.nvim_create_user_command("NeotestRunDap", function()
         nt.run.run({ strategy = "dap" })
      end, {})
      vim.api.nvim_create_user_command("NeotestRunFileDap", function()
         nt.run.run(vim.fn.expand("%"), { strategy = "dap" })
      end, {})
      vim.api.nvim_create_user_command("NeotestAttach", function()
         nt.run.attach()
      end, {})
   end,
}
