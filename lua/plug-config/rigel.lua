-- Ensure truecolor and apply rigel; if not installed yet, retry after Lazy completes
vim.o.termguicolors = true

local function apply()
   local ok = pcall(vim.cmd.colorscheme, "rigel")
   return ok
end

if not apply() then
   vim.api.nvim_create_autocmd("User", {
      pattern = "LazyDone",
      once = true,
      callback = function()
         pcall(apply)
      end,
   })
end

