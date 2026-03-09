local M = {}

local function to_module_name(path)
   -- Convert absolute or relative lua path to module name
   -- e.g. /.../lua/plugins/ui/treesitter.lua -> plugins.ui.treesitter
   local lua_root = vim.fs.normalize(vim.fn.stdpath("config") .. "/lua/")
   path = vim.fs.normalize(path)
   local rel = path:gsub("^" .. vim.pesc(lua_root), "")
   rel = rel:gsub("%.lua$", "")
   rel = rel:gsub("/", ".")
   return rel
end

local function flatten_specs(acc, spec)
   if type(spec) == "function" then
      local ok, res = pcall(spec)
      if not ok then
         return acc
      end
      spec = res
   end
   if type(spec) ~= "table" then
      return acc
   end
   if spec[1] ~= nil then
      for _, s in ipairs(spec) do
         table.insert(acc, s)
      end
   else
      table.insert(acc, spec)
   end
   return acc
end

function M.collect(dirs)
   local specs = {}
   for _, dir in ipairs(dirs) do
      -- dir is a module-like path: plugins/ui
      local base = vim.fn.stdpath("config") .. "/lua/" .. dir
      local files = vim.fn.glob(base .. "/**/*.lua", true, true)
      for _, file in ipairs(files) do
         -- Skip files that look like pure config helpers by convention
         local name = file:match("([^/]+)%.lua$") or ""
         if name ~= "init" then
            local mod = to_module_name(file)
            local ok, ret = pcall(require, mod)
            if ok then
               flatten_specs(specs, ret)
            end
         else
            -- If there's an init.lua, also allow it to return specs
            local mod = to_module_name(file:gsub("%.lua$", ""))
            local ok, ret = pcall(require, mod)
            if ok then
               flatten_specs(specs, ret)
            end
         end
      end
   end
   return specs
end

return M

