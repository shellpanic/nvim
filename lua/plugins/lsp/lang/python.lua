local devtools = require("devtools")

return {
   basedpyright = {
      settings = {
         python = {
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
         settings = {
            configuration = devtools.path("ruff.toml"),
            configurationPreference = "filesystemFirst",
         },
      },
   },
}
