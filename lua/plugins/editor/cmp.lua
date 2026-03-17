return {
   {
      "L3MON4D3/LuaSnip",
      lazy = false,
      build = "make install_jsregexp",
   },
   "saadparwaiz1/cmp_luasnip",
   "rafamadriz/friendly-snippets",
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-buffer",
         "hrsh7th/cmp-path",
         "hrsh7th/cmp-cmdline",
         "onsails/lspkind.nvim",
      },
      config = function()
         vim.opt.completeopt = { "menu", "menuone", "noselect" }
         require("luasnip.loaders.from_vscode").lazy_load()
         pcall(function()
            require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
         end)
         local luasnip = require("luasnip")
         local lspkind = require("lspkind")
         local cmp = require("cmp")
         local select_opts = { behavior = cmp.SelectBehavior.Select }
         local cmp_compare = cmp.config.compare
         local context = require("cmp.config.context")
         local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
               return false
            end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
         end
         cmp.setup({
            enabled = function()
               if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                  return false
               end
               return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
            end,
            preselect = cmp.PreselectMode.None,
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            -- Ensure the menu auto-opens on text changes when there are items
            completion = {
               autocomplete = { cmp.TriggerEvent.TextChanged },
               keyword_length = 1,
            },
            matching = {
               disallow_partial_fuzzy_matching = true,
               disallow_prefix_unmatching = true,
            },
            performance = { debounce = 20, throttle = 30, fetching_timeout = 200 },
            sources = {
               { name = "path", keyword_length = 2 },
               -- Show LSP items as soon as they are available (incl. trigger chars)
               { name = "nvim_lsp", keyword_length = 0 },
               { name = "buffer", keyword_length = 4, option = { get_bufnrs = function() return { vim.api.nvim_get_current_buf() } end } },
               { name = "luasnip", keyword_length = 2 },
            },
            window = {
               completion = cmp.config.window.bordered({
                  border = "single",
                  winhighlight = "Normal:NormalFloat,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
               }),
               documentation = cmp.config.window.bordered({
                  border = "single",
                  winhighlight = "Normal:NormalFloat,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
               }),
            },
            sorting = {
               priority_weight = 2,
               comparators = (function()
                  -- Deprioritize items with leading underscores
                  local function leading_underscore(entry1, entry2)
                     local label1 = entry1.completion_item.label or ""
                     local label2 = entry2.completion_item.label or ""
                     local _, count1 = label1:gsub("^_+", "")
                     local _, count2 = label2:gsub("^_+", "")
                     if count1 ~= count2 then
                        return count1 < count2
                     end
                  end
                  local list = {
                     cmp_compare.offset,
                     cmp_compare.exact,
                     cmp_compare.score,
                     cmp_compare.recently_used,
                     cmp_compare.locality,
                     leading_underscore,
                     cmp_compare.kind,
                     cmp_compare.sort_text,
                     cmp_compare.length,
                     cmp_compare.order,
                  }
                  local out = {}
                  for _, f in ipairs(list) do
                     if f ~= nil then
                        table.insert(out, f)
                     end
                  end
                  return out
               end)(),
            },
            formatting = {
               format = lspkind.cmp_format({
                  mode = "symbol",
                  maxwidth = 50,
                  ellipsis_char = "...",
                  show_labelDetails = true,
                  symbol_map = {
                     Text = "󰉿",
                     Method = "󰆧",
                     Function = "󰊕",
                     Constructor = "",
                     Field = "󰜢",
                     Variable = "󰀫",
                     Class = "󰠱",
                     Interface = "",
                     Module = "",
                     Property = "󰜢",
                     Unit = "󰑭",
                     Value = "󰎠",
                     Enum = "",
                     Keyword = "󰌋",
                     Snippet = "",
                     Color = "󰏘",
                     File = "󰈙",
                     Reference = "󰈇",
                     Folder = "󰉋",
                     EnumMember = "",
                     Constant = "󰏿",
                     Struct = "󰙅",
                     Event = "",
                     Operator = "󰆕",
                     Copilot = "",
                     TypeParameter = "",
                  },
               }),
            },
            mapping = {
               ["<C-b>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
               ["<C-k>"] = cmp.mapping.select_prev_item(),
               ["<C-j>"] = cmp.mapping.select_next_item(),
               -- Confirm selection: Enter confirms only when an item is selected
               ["<CR>"] = cmp.mapping(function(fallback)
                  if cmp.visible() and cmp.get_selected_entry() then
                     cmp.confirm({ select = false })
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               -- Esc closes the menu if open; otherwise behaves normally
               ["<Esc>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.abort()
                  else
                     fallback()
                  end
               end, { "i" }),
               ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_next_item(select_opts)
                  elseif has_words_before() then
                     cmp.complete()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item(select_opts)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<C-S-f>"] = cmp.mapping(function(fallback)
                  if luasnip.jumpable(1) then
                     luasnip.jump(1)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<C-S-b>"] = cmp.mapping(function(fallback)
                  if luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
            },
            experimental = { ghost_text = true },
         })

         cmp.setup.filetype(
            "gitcommit",
            { sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }) }
         )
         -- Markdown: enable render-markdown source only for these filetypes
         cmp.setup.filetype({ "markdown", "markdown.mdx" }, {
            sources = cmp.config.sources({ { name = "render-markdown" } }, {
               { name = "buffer", keyword_length = 3 },
               { name = "path", keyword_length = 2 },
            }),
         })
         -- Cargo.toml: enable Crates completion
         pcall(function()
            cmp.setup.filetype("toml", {
               sources = cmp.config.sources({ { name = "crates" } }, {
                  { name = "path", keyword_length = 2 },
                  { name = "buffer", keyword_length = 3 },
               }),
            })
         end)
         -- Cmdline completion: use Ctrl-j/k to navigate; Esc to cancel
         local cmdline_mappings = cmp.mapping.preset.cmdline()
         -- Let <Down>/<Up> behave normally (history), not control cmp
         cmdline_mappings["<Down>"] = cmp.mapping(function(fallback) fallback() end, { "c" })
         cmdline_mappings["<Up>"] = cmp.mapping(function(fallback) fallback() end, { "c" })
         cmdline_mappings["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            else
               fallback()
            end
         end, { "c" })
         cmdline_mappings["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            else
               fallback()
            end
         end, { "c" })
         -- Enter confirms only when an entry is selected; otherwise runs the command
         cmdline_mappings["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
               cmp.confirm({ select = false })
            else
               fallback()
            end
         end, { "c" })
         -- Esc closes the menu if open; otherwise leaves cmdline as usual
         cmdline_mappings["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.abort()
            else
               fallback()
            end
         end, { "c" })

         cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmdline_mappings,
            sources = { { name = "buffer" } },
         })
         cmp.setup.cmdline(":", {
            mapping = cmdline_mappings,
            sources = cmp.config.sources(
               { { name = "path" } },
               { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
            ),
         })

         -- Integrate with nvim-autopairs: add () on confirm, but skip when LSP provides a snippet (to keep placeholders)
         pcall(function()
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local handler = cmp_autopairs.on_confirm_done()
            cmp.event:on("confirm_done", function(evt)
               local ok, entry = pcall(function() return evt.entry end)
               if not ok or not entry then return end
               local item = entry:get_completion_item()
               if item and item.insertTextFormat == 2 then
                  -- LSP already expands a snippet with parameters; don't add extra parens
                  return
               end
               handler(evt)
            end)
         end)
      end,
   },
}
