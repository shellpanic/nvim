local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   -- Docker Compose file skeleton
   s(
      "dcomp",
      fmt(
         [[
version: "{}"
services:
  {}:
    image: {}
    ports:
      - "{}:{}"
    environment:
      - {}={}
    volumes:
      - {}:{}
    depends_on:
      - {}
]],
         { i(1, "3.9"), i(2, "app"), i(3, "nginx:latest"), i(4, "8080"), i(5, "80"), i(6, "KEY"), i(7, "value"), i(8, "./data"), i(9, "/data"), i(10, "db") }
      )
   ),

   -- Docker Compose service block
   s(
      "dsvc",
      fmt(
         [[
{}:
  image: {}
  ports:
    - "{}:{}"
  environment:
    - {}={}
  volumes:
    - {}:{}
  depends_on:
    - {}
]],
         { i(1, "service"), i(2, "repo/image:tag"), i(3, "8080"), i(4, "80"), i(5, "KEY"), i(6, "value"), i(7, "./data"), i(8, "/data"), i(9, "db") }
      )
   ),
}

