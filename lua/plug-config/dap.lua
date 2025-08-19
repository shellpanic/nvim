local dapui = require("dapui")
dapui.setup()

local dap = require("dap")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "󰋇", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
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

dap.listeners.after.event_initialized["dapui_config"] = function()
   dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
   dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
   dapui.close()
end

-- Allow vscode like launch.json configurations
require("dap.ext.vscode").load_launchjs(nil, { python = { "py" } })

-- Single DAP client configuration
-- Python
local dap_python = require("dap-python")

dap_python.setup("~/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"
table.insert(require("dap").configurations.python, {
   type = "python",
   request = "launch",
   name = "FastApi App",
   module = "uvicorn",
   args = { "app.main:app", "--reload" },
})
