local devtools = require("devtools")
local ruff_settings = { configurationPreference = "filesystemFirst" }
local ruff_config = devtools.existing_path("ruff.toml")
if ruff_config then
   ruff_settings.configuration = ruff_config
end

return {
   basedpyright = {
      settings = {
         basedpyright = {
            analysis = {
               typeCheckingMode = "basic",
               autoImportCompletions = true,
               diagnosticMode = "workspace",
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
      init_options = {
         settings = ruff_settings,
      },
   },
}
