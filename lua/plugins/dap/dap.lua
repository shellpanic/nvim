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
         "DapPythonTestMethod",
      },
      -- UI integration is optional; avoid forcing install at startup
      dependencies = {
         {
            "rcarriga/nvim-dap-ui",
            optional = true,
            dependencies = { "nvim-neotest/nvim-nio" },
         },
      },
      config = function()
         local dap = require("dap")
         local has_dapui, dapui = pcall(require, "dapui")
         if has_dapui then
            pcall(dapui.setup)
            dap.listeners.after.event_initialized["dapui_config"] = function()
               dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
               dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
               dapui.close()
            end
         end
         -- Some plugins still call deprecated load_launchjs; neutralize to avoid warnings
         pcall(function()
            local vscode = require("dap.ext.vscode")
            if type(vscode.load_launchjs) == "function" then
               vscode.load_launchjs = function() end
            end
         end)
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
            python_path = python_path or vim.fn.exepath("python3") or "python3"
            dap_python.setup(python_path)
            dap_python.test_runner = "pytest"
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
               args = { "app.main:app", "--reload" },
            })
         end)
      end,
   },
   -- Load only for Python files to avoid startup cost
   {
      "mfussenegger/nvim-dap-python",
      ft = { "python" },
      dependencies = { "mfussenegger/nvim-dap" },
   },
}
