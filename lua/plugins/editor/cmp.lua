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
         local luasnip = require("luasnip")
         local lspkind = require("lspkind")
         local cmp = require("cmp")
         local select_opts = { behavior = cmp.SelectBehavior.Select }
         local cmp_compare = cmp.config.compare
         local ok_copilot, copilot_cmp = pcall(require, "copilot_cmp.comparators")
         local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
               return false
            end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
         end
         cmp.setup({
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            completion = { keyword_length = 1, keyword_completion = 1 },
            sources = {
               { name = "path" },
               { name = "render-markdown" },
               { name = "nvim_lsp", keyword_length = 1 },
               { name = "buffer", keyword_length = 3 },
               { name = "luasnip", keyword_length = 2 },
               { name = "copilot", keyword_length = 2 },
            },
            window = { documentation = cmp.config.window.bordered() },
            sorting = {
               priority_weight = 2,
               comparators = (function()
                  local list = {
                     ok_copilot and copilot_cmp.prioritize or nil,
                     cmp_compare.offset,
                     cmp_compare.exact,
                     cmp_compare.score,
                     cmp_compare.recently_used,
                     cmp_compare.locality,
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
               ["<CR>"] = cmp.mapping.confirm({ select = true }),
               ["<C-Esc>"] = cmp.mapping.confirm({ select = false }),
               ["<C-e>"] = cmp.mapping.abort(),
               ["<Tab>"] = cmp.mapping(function(fallback)
                  local col = vim.fn.col(".") - 1
                  if cmp.visible() and has_words_before() then
                     cmp.select_next_item(select_opts)
                  elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                     fallback()
                  else
                     return
                  end
               end, { "i", "n", "s" }),
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.select_prev_item(select_opts)
                  else
                     fallback()
                  end
               end, { "i", "n", "s" }),
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
         })

         cmp.setup.filetype(
            "gitcommit",
            { sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer" } }) }
         )
         cmp.setup.cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })
         cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
         })
      end,
   },
}
