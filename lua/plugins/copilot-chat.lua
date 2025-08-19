return {
   "CopilotC-Nvim/CopilotChat.nvim",
   dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
   },
   build = "make tiktoken",
   opts = {
      model = "gpt-4o",
      agent = "copilot",
      temperature = 0.1,
      remember_as_sticky = true,
      window = {
         layout = "vertical",
         width = 0.3,
         height = 0.5,
         relative = "editor",
         border = "single",
         title = "Copilot Chat",
      },
      highlight_headers = true,
      question_header = "##  User",
      answer_header = "##  Copilot",
      separator = "        ",
      error_header = "> [!ERROR] Error",
      mappings = {
         complete = {
            insert = "<A-Right>",
         },
      },
   },
   config = function(_, opts)
      -- Load project local prompts
      local chat = require("CopilotChat")

      local function load_prompts_from_dir(dir)
         local prompts = {}
         local files = vim.fn.globpath(dir, "*.txt", false, true)
         for _, file in ipairs(files) do
            local name = vim.fn.fnamemodify(file, ":t:r")
            local content = vim.fn.readfile(file)
            if name ~= "system" then
               prompts[name] = table.concat(content, "\n")
            end
         end
         return prompts
      end

      local prompt_dir = vim.fn.getcwd() .. "/.copilot"
      local system_prompt_path = prompt_dir .. "/system.txt"
      local system_prompt = nil
      if vim.fn.filereadable(system_prompt_path) == 1 then
         system_prompt = table.concat(vim.fn.readfile(system_prompt_path), "\n")
      end

      -- Merge user opts with dynamic prompt config
      local full_opts = vim.tbl_deep_extend("force", opts, {
         prompts = load_prompts_from_dir(prompt_dir),
         system_prompt = system_prompt,
      })

      chat.setup(full_opts)
   end,
}
