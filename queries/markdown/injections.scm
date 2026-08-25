; Use Neovim's native injection capture instead of nvim-treesitter's
; set-lang-from-info-string! directive, which is incompatible with the
; Neovim 0.12 query match shape.
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
