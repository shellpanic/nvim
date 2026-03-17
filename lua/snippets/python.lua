local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   -- Main guard
   s(
      "main",
      fmt(
         [[
def main() -> None:
    {}

if __name__ == "__main__":
    main()
]],
         { i(1, "pass") }
      )
   ),

   -- Dataclass
   s(
      "dataclass",
      fmt(
         [[
from dataclasses import dataclass

@dataclass
class {}:
    {}: {}
    {}: {}
]],
         { i(1, "Name"), i(2, "field1"), i(3, "str"), i(4, "field2"), i(5, "int") }
      )
   ),

   -- Pytest test function
   s(
      "pytest",
      fmt(
         [[
import pytest

def test_{}() -> None:
    {}
]],
         { i(1, "subject"), i(2, "assert True") }
      )
   ),

   -- Function with docstring
   s(
      "def",
      fmt(
         [[
def {}({}) -> {}:
    """{}"""
    {}
]],
         { i(1, "func"), i(2), i(3, "None"), i(4, "Summary."), i(5, "pass") }
      )
   ),

   -- PDB breakpoint
   s("pdb", t({ "import pdb; pdb.set_trace()" })),
}
