-- Compatibility shim for Neovim 0.12 Treesitter directive crashes
-- Harden nvim-treesitter's set-lang-from-info-string! to avoid nil-node errors

local M = {}

function M.setup()
  local ok, query = pcall(require, "vim.treesitter.query")
  if not ok then
    return
  end

  -- Force override even if plugin already registered it
  local opts = { force = true, all = false }

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = match[capture_id]
    if not node then
      return
    end

    -- Some environments on 0.12 report non-TSNode here; guard before calling get_node_text
    local ok_text, injection_alias = pcall(function()
      return vim.treesitter.get_node_text(node, bufnr)
    end)
    if not ok_text or type(injection_alias) ~= "string" then
      return
    end

    injection_alias = injection_alias:lower()

    -- Mirror nvim-treesitter's language alias resolution for markdown info strings
    local non_filetype_match_injection_language_aliases = {
      ex = "elixir",
      pl = "perl",
      sh = "bash",
      uxn = "uxntal",
      ts = "typescript",
    }

    local function get_parser_from_markdown_info_string(alias)
      local ft = (vim.filetype and vim.filetype.match) and vim.filetype.match({ filename = "a." .. alias }) or nil
      return ft or non_filetype_match_injection_language_aliases[alias] or alias
    end

    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
  end, opts)
end

return M

