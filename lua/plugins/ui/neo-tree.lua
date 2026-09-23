return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
   },
   cmd = { "Neotree" },
   config = function()
      require("neo-tree").setup({
         close_if_last_window = true,
         popup_border_style = "rounded",
         enable_git_status = true,
         enable_diagnostics = true,
         open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
         sort_case_insensitive = false,
         sort_function = nil,
         default_component_configs = {
            container = { enable_character_fade = true },
            indent = {
               indent_size = 2,
               padding = 1,
               with_markers = true,
               indent_marker = "│",
               last_indent_marker = "└",
               highlight = "NeoTreeIndentMarker",
               with_expanders = nil,
               expander_collapsed = "",
               expander_expanded = "",
               expander_highlight = "NeoTreeExpander",
            },
            icon = {
               folder_closed = "",
               folder_open = "",
               folder_empty = "󰜌",
               default = "*",
               highlight = "NeoTreeFileIcon",
            },
            modified = { symbol = "[+]", highlight = "NeoTreeModified" },
            name = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
            git_status = {
               symbols = {
                  added = "✚",
                  modified = "",
                  deleted = "✖",
                  renamed = "󰁕",
                  untracked = "",
                  ignored = "",
                  unstaged = "󰄱",
                  staged = "",
                  conflict = "",
               },
            },
            file_size = { enabled = true, required_width = 64 },
            type = { enabled = true, required_width = 122 },
            last_modified = { enabled = true, required_width = 88 },
            created = { enabled = true, required_width = 110 },
            symlink_target = { enabled = false },
         },
         commands = {},
         window = { position = "right", width = 40, mapping_options = { noremap = true, nowait = true }, mappings = {} },
         nesting_rules = {},
         filesystem = {
            components = {
               root_git_status = function(_, node)
                  if node.type ~= "directory" or node:get_depth() ~= 1 then
                     return {}
                  end

                  local git = require("neo-tree.git")
                  local path = require("neo-tree.utils").normalize_path(node.path)
                  local worktree = git.worktrees[path]
                  if not worktree or not worktree.status then
                     return {}
                  end

                  for _, status in pairs(worktree.status) do
                     local code = type(status) == "table" and status[1] or status
                     if code ~= "!" then
                        return { text = "", highlight = "NeoTreeGitModified" }
                     end
                  end

                  return {}
               end,
            },
            renderers = {
               directory = {
                  { "indent" },
                  { "icon" },
                  { "current_filter" },
                  {
                     "container",
                     content = {
                        { "name", zindex = 10 },
                        { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
                        { "clipboard", zindex = 10 },
                        {
                           "diagnostics",
                           errors_only = true,
                           zindex = 20,
                           align = "right",
                           hide_when_expanded = true,
                        },
                        { "root_git_status", zindex = 10, align = "right" },
                        { "git_status", zindex = 10, align = "right", hide_when_expanded = false },
                        { "file_size", zindex = 10, align = "right" },
                        { "type", zindex = 10, align = "right" },
                        { "last_modified", zindex = 10, align = "right" },
                        { "created", zindex = 10, align = "right" },
                     },
                  },
               },
            },
            filtered_items = {
               visible = false,
               hide_dotfiles = false,
               hide_gitignored = false,
               hide_hidden = true,
               hide_by_name = {},
               hide_by_pattern = {},
               always_show = {},
               never_show = {},
               never_show_by_pattern = {},
            },
            follow_current_file = { enabled = true, leave_dirs_open = false },
            window = { mappings = {}, fuzzy_finder_mappings = {} },
            commands = {},
         },
         buffers = {
            follow_current_file = { enabled = true, leave_dirs_open = false },
            group_empty_dirs = true,
            show_unloaded = true,
            window = { mappings = {} },
         },
         git_status = { window = { position = "float", mappings = {} } },
      })
   end,
}
