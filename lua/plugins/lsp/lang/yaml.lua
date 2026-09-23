return {
   yamlls = {
      filetypes = { "yaml" },
      settings = {
         yaml = {
            completion = true,
            validate = true,
            hover = true,
            format = { enable = false },
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
            schemas = {
               ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                  "docker-compose*.yml",
                  "docker-compose*.yaml",
                  "compose*.yml",
                  "compose*.yaml",
               },
            },
         },
      },
   },
}
