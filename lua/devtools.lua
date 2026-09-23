local M = {}

local config_home = vim.env.XDG_CONFIG_HOME
if not config_home or config_home == "" then
   config_home = vim.fs.joinpath(vim.uv.os_homedir(), ".config")
end

M.root = vim.env.DEVTOOLS_CONFIG_HOME
if not M.root or M.root == "" then
   M.root = vim.fs.joinpath(config_home, "devtools")
end

local project_configs = {
   markdownlint = {
      names = {
         ".markdownlint.jsonc",
         ".markdownlint.json",
         ".markdownlint.yaml",
         ".markdownlint.yml",
         ".markdownlintrc",
      },
   },
   prettier = {
      names = {
         ".prettierrc",
         ".prettierrc.json",
         ".prettierrc.yml",
         ".prettierrc.yaml",
         ".prettierrc.json5",
         ".prettierrc.js",
         ".prettierrc.cjs",
         ".prettierrc.mjs",
         ".prettierrc.ts",
         ".prettierrc.cts",
         ".prettierrc.mts",
         ".prettierrc.toml",
         "prettier.config.js",
         "prettier.config.cjs",
         "prettier.config.mjs",
         "prettier.config.ts",
         "prettier.config.cts",
         "prettier.config.mts",
      },
      package_json_key = "prettier",
   },
   stylua = { names = { ".stylua.toml", "stylua.toml" } },
   yamllint = { names = { ".yamllint", ".yamllint.yaml", ".yamllint.yml" } },
}

local function file_exists(path)
   return vim.uv.fs_stat(path) ~= nil
end

local function start_directory(path)
   path = path and path ~= "" and path or vim.api.nvim_buf_get_name(0)
   path = path ~= "" and path or vim.uv.cwd()
   local stat = vim.uv.fs_stat(path)
   return stat and stat.type == "directory" and path or vim.fs.dirname(path)
end

local function executable_in_venv(directory, name)
   local windows = vim.uv.os_uname().sysname:match("Windows") ~= nil
   local relative = windows and { ".venv", "Scripts", name .. ".exe" } or { ".venv", "bin", name }
   local candidate = vim.fs.joinpath(directory, unpack(relative))
   return vim.fn.executable(candidate) == 1 and candidate or nil
end

local function package_json_has_key(path, key)
   if not file_exists(path) then
      return false
   end
   local ok_read, lines = pcall(vim.fn.readfile, path)
   if not ok_read then
      return false
   end
   local ok_decode, package = pcall(vim.json.decode, table.concat(lines, "\n"))
   return ok_decode and type(package) == "table" and package[key] ~= nil
end

function M.path(name)
   return vim.fs.joinpath(M.root, name)
end

function M.existing_path(name)
   local path = M.path(name)
   return file_exists(path) and path or nil
end

---Find an executable in the closest exact `.venv` directory.
---This deliberately ignores sibling CI/quality environments.
---@param name string
---@param start? string
---@return string?
function M.find_project_executable(name, start)
   local directory = start_directory(start)

   while directory do
      local executable = executable_in_venv(directory, name)
      if executable then
         return executable
      end

      local parent = vim.fs.dirname(directory)
      if not parent or parent == directory then
         break
      end
      directory = parent
   end
end

---@param start? string
---@return string
function M.python_executable(start)
   local project_python = M.find_project_executable("python", start)
   if project_python then
      return project_python
   end

   if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
      local bin = vim.uv.os_uname().sysname:match("Windows") and "Scripts/python.exe" or "bin/python"
      local active_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, bin)
      if vim.fn.executable(active_python) == 1 then
         return active_python
      end
   end

   for _, name in ipairs({ "python3", "python" }) do
      local executable = vim.fn.exepath(name)
      if executable ~= "" then
         return executable
      end
   end

   return "python3"
end

function M.find_project_config(tool, filename)
   local spec = assert(project_configs[tool], "Unknown devtool: " .. tool)
   local start = filename and filename ~= "" and filename or vim.uv.cwd()
   local stat = vim.uv.fs_stat(start)
   local directory = stat and stat.type == "directory" and start or vim.fs.dirname(start)
   local home = vim.uv.os_homedir()

   while directory and directory ~= home do
      for _, name in ipairs(spec.names) do
         local candidate = vim.fs.joinpath(directory, name)
         if file_exists(candidate) then
            return candidate
         end
      end

      if spec.package_json_key then
         local package_json = vim.fs.joinpath(directory, "package.json")
         if package_json_has_key(package_json, spec.package_json_key) then
            return package_json
         end
      end

      local parent = vim.fs.dirname(directory)
      if not parent or parent == directory then
         break
      end
      directory = parent
   end
end

return M
