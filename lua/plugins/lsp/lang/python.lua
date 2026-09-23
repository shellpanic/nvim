local devtools = require("devtools")
local ruff_settings = { configurationPreference = "filesystemFirst" }
local ruff_config = devtools.existing_path("ruff.toml")
if ruff_config then
   ruff_settings.configuration = ruff_config
end

local function start_ruff(dispatchers, config)
   local project_ruff = devtools.find_project_executable("ruff", config.root_dir)
   local ruff = project_ruff or vim.fn.exepath("ruff")
   ruff = ruff ~= "" and ruff or "ruff"
   return vim.lsp.rpc.start({ ruff, "server" }, dispatchers, {
      cwd = config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
   })
end

return {
   basedpyright = {
      settings = {
         basedpyright = {
            analysis = {
               typeCheckingMode = "basic",
               autoImportCompletions = true,
               -- Avoid indexing/diagnosing every Python file in large monorepos.
               diagnosticMode = "openFilesOnly",
               inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  parameterNames = "all",
                  parameterTypes = true,
               },
            },
         },
      },
   },
   ruff = {
      -- Resolve after root detection so each project gets its pinned Ruff.
      cmd = start_ruff,
      init_options = {
         settings = ruff_settings,
      },
   },
}
