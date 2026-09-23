return {
   {
      "mfussenegger/nvim-dap",
      -- Only load when using DAP commands
      cmd = {
         "DapToggleBreakpoint",
         "DapTerminate",
         "DapContinue",
         "DapStepOver",
         "DapStepInto",
         "DapStepOut",
         "DapPause",
         "DapRunLast",
         "DapClearBreakpoints",
         "DapPythonTestMethod",
         "DapUiToggle",
         "DapUiOpen",
         "DapUiClose",
         "DapUiEval",
         "DapSetConditionalBreakpoint",
         "DapSetLogPoint",
         "DapReplToggle",
      },
      dependencies = {
         "nvim-neotest/nvim-nio",
         "rcarriga/nvim-dap-ui",
      },
      config = function()
         local dap = require("dap")
         local dapui = require("dapui")
         dapui.setup({
            floating = { border = "rounded" },
            layouts = {
               {
                  elements = {
                     { id = "scopes", size = 0.4 },
                     { id = "breakpoints", size = 0.2 },
                     { id = "stacks", size = 0.2 },
                     { id = "watches", size = 0.2 },
                  },
                  position = "left",
                  size = 40,
               },
               {
                  elements = {
                     { id = "repl", size = 0.5 },
                     { id = "console", size = 0.5 },
                  },
                  position = "bottom",
                  size = 10,
               },
            },
            render = { indent = 1, max_value_lines = 25 },
         })
         vim.api.nvim_create_user_command("DapUiToggle", function()
            dapui.toggle()
         end, {})
         vim.api.nvim_create_user_command("DapUiOpen", function()
            dapui.open()
         end, {})
         vim.api.nvim_create_user_command("DapUiClose", function()
            dapui.close()
         end, {})
         vim.api.nvim_create_user_command("DapUiEval", function(opts)
            local expression = opts.args ~= "" and opts.args or nil
            if opts.range > 0 then
               local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), {
                  type = vim.fn.visualmode(),
               })
               expression = table.concat(lines, "\n")
            end
            dapui.eval(expression, { enter = true })
         end, { nargs = "?", range = true })
         dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
         end
         dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
         end
         dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
         end

         vim.api.nvim_create_user_command("DapSetConditionalBreakpoint", function()
            vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
               if condition and condition ~= "" then
                  dap.set_breakpoint(condition)
               end
            end)
         end, {})
         vim.api.nvim_create_user_command("DapSetLogPoint", function()
            vim.ui.input({ prompt = "Log point message: " }, function(message)
               if message and message ~= "" then
                  dap.set_breakpoint(nil, nil, message)
               end
            end)
         end, {})
         vim.api.nvim_create_user_command("DapReplToggle", function()
            dap.repl.toggle()
         end, {})
         vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
         vim.fn.sign_define(
            "DapStopped",
            { text = "󰋇", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
         )
         vim.fn.sign_define(
            "DapBreakpointCondition",
            { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
         )
         vim.fn.sign_define(
            "DapBreakpointRejected",
            { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
         )
         vim.fn.sign_define(
            "DapLogPoint",
            { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
         )
         -- Python adapter convenience
         local function setup_debugpy()
            local ok, dap_python = pcall(require, "dap-python")
            if not ok then
               return
            end
            local python_path = nil
            local ok_mason, mason_registry = pcall(require, "mason-registry")
            if ok_mason then
               local ok_pkg, pkg = pcall(mason_registry.get_package, "debugpy")
               if ok_pkg and pkg and pkg.get_install_path then
                  local install_path = pkg:get_install_path()
                  python_path = install_path .. "/venv/bin/python"
               end
            end
            local system_python = vim.fn.exepath("python3")
            if system_python == "" then
               system_python = "python3"
            end
            python_path = python_path or system_python
            dap_python.setup(python_path)
            dap_python.test_runner = "pytest"
            dap_python.resolve_python = function()
               return require("devtools").python_executable(vim.api.nvim_buf_get_name(0))
            end
         end
         setup_debugpy()
         -- user command wrapper for python test method
         pcall(function()
            vim.api.nvim_create_user_command("DapPythonTestMethod", function()
               require("dap-python").test_method()
            end, {})
         end)
         -- Example Python launch config
         pcall(function()
            table.insert(dap.configurations.python, {
               type = "python",
               request = "launch",
               name = "FastApi App",
               module = "uvicorn",
               args = { "app.main:app" },
            })
         end)

         vim.api.nvim_create_autocmd("VimLeavePre", {
            group = vim.api.nvim_create_augroup("dap_process_cleanup", { clear = true }),
            callback = function()
               pcall(dap.terminate)
               pcall(dapui.close)
            end,
         })
      end,
   },
   -- Load only for Python files to avoid startup cost
   {
      "mfussenegger/nvim-dap-python",
      ft = { "python" },
      dependencies = { "mfussenegger/nvim-dap" },
   },
}
