local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   s(
      "stage",
      fmt(
         [[
FROM {} AS {}
WORKDIR {}
COPY {} {}
RUN {}
CMD [{}]
]],
         {
            i(1, "alpine:latest"),
            i(2, "build"),
            i(3, "/app"),
            i(4, "."),
            i(5, "/app"),
            i(6, "echo build"),
            i(7, '"/bin/sh"'),
         }
      )
   ),
}
