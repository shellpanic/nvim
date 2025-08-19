vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("luasnip.loaders.from_vscode").lazy_load()

local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp = require("cmp")

local select_opts = { behavior = cmp.SelectBehavior.Select }

local has_words_before = function()
   if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
   end
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
   snippet = {
      -- set snippet engine
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },
   completion = {
      keyword_length = 1,
      keyword_completion = 1,
   },
   sources = {
      { name = "path" },
      { name = "render-markdown" },
      { name = "nvim_lsp", keyword_length = 1 },
      { name = "buffer", keyword_length = 3 },
      { name = "luasnip", keyword_length = 2 },
      { name = "copilot", keyword_length = 2 },
   },
   window = {
      -- completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },
   sorting = {
      priority_weight = 2,
      comparators = {
         require("copilot_cmp.comparators").prioritize,

         -- Below is the default comparitor list and order for nvim-cmp
         cmp.config.compare.offset,
         -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
         cmp.config.compare.exact,
         cmp.config.compare.score,
         cmp.config.compare.recently_used,
         cmp.config.compare.locality,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order,
      },
   },
   formatting = {
      format = lspkind.cmp_format({
         mode = "symbol", -- show only symbol annotations
         maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
         -- can also be a function to dynamically calculate max width such as
         -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
         ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
         show_labelDetails = true, -- show labelDetails in menu. Disabled by default
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

         -- The function below will be called before any actual modifications from lspkind
         -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
         -- before = function (entry, vim_item)
         --   ...
         --   return vim_item
         -- end
      }),
   },
   mapping = {
      -- Use <C-b/f> to scroll the docs
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      -- Use <C-k/j> to switch in items
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      -- Confirm or abort the selected selection
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Esc>"] = cmp.mapping.confirm({ select = false }),
      ["<C-e>"] = cmp.mapping.abort(),

      -- Open completion, switch through list
      ["<Tab>"] = cmp.mapping(function(fallback)
         local col = vim.fn.col(".") - 1
         if cmp.visible() and has_words_before() then
            cmp.select_next_item(select_opts)
         elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
         else
            -- cmp.complete()
            return
         end
      end, { "i", "n", "s" }), -- i - insert mode; s - select mode

      ["<C-Space>"] = cmp.mapping.complete(),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item(select_opts)
         else
            fallback()
         end
      end, { "i", "n", "s" }),

      -- Switch through snippets
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

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
   sources = cmp.config.sources({
      { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
   }, {
      { name = "buffer" },
   }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = "buffer" },
   },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = "path" },
   }, {
      { name = "cmdline" },
   }),
})
