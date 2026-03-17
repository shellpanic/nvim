local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   -- Unit test
   s(
      "test",
      fmt(
         [[
#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn {}() {{
        {}
    }}
}}
]],
         { i(1, "it_works"), i(2, "assert_eq!(2 + 2, 4);") }
      )
   ),

   -- Derive common traits
   s("derive", fmt("#[derive({}, Debug, Clone)]", { i(1, "Serialize, Deserialize") })),

   -- Result main
   s(
      "rmain",
      fmt(
         [[
fn main() -> Result<(), {}> {{
    {}
    Ok(())
}}
]],
         { i(1, "Box<dyn std::error::Error>"), i(2) }
      )
   ),
}

