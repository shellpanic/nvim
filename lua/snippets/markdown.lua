local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   -- Code fence with language and body
   s(
      "```",
      fmt(
         [[
```{}
{}
```
]],
         { i(1, "lang"), i(2) }
      )
   ),

   -- Markdown link
   s("link", fmt("[{}]({})", { i(1, "text"), i(2, "url") })),

   -- Frontmatter
   s(
      "front",
      fmt(
         [[
---
title: {}
date: {}
tags: [{}]
---
]],
         { i(1, "Title"), i(2, os.date("%Y-%m-%d")), i(3, "tag1, tag2") }
      )
   ),
}

