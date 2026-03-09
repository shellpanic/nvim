require("neotest").setup({
   adapters = {
      require("rustaceanvim.neotest"),
      require("neotest-python")({
         dap = { justMyCode = false },
      }),
   },
   discovery = {
      -- Drastically improve performance in ginormous projects by
      -- only AST-parsing the currently opened buffer.
      enabled = false,
      -- Number of workers to parse files concurrently.
      -- A value of 0 automatically assigns number based on CPU.
      -- Set to 1 if experiencing lag.
      concurrent = 0,
   },
   running = {
      -- Run tests concurrently when an adapter provides multiple commands to run.
      concurrent = true,
   },
   summary = {
      -- Enable/disable animation of icons.
      animated = true,
   },
})
