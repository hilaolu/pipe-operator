from typing import no_type_check
from unittest import TestCase

from pipe_operator.elixir_flow.pipe import elixir_pipe


def my_func(a, b):
    return f"{a}-{b}"


class KeywordPlaceholderTestCase(TestCase):
    @no_type_check
    @elixir_pipe
    def test_keyword_placeholder(self) -> None:
        # Test 1: Placeholder in keyword argument
        op = "1" >> my_func(b="2", a=_)
        self.assertEqual(op, "1-2")

        # Test 2: Placeholder in keyword argument with other args
        op = "1" >> my_func(a=_, b="2")
        self.assertEqual(op, "1-2")

        # Test 3: Placeholder mixed with positional args
        # expected: my_func("prefix", a="1", b="suffix") if "1" is passed
        # wait, my_func takes a, b.
        # let's define a new func
        def three_args(x, y, z):
            return f"{x}:{y}:{z}"
        
        op = "val" >> three_args("prefix", z="suffix", y=_)
        # Should become three_args("prefix", z="suffix", y="val") -> "prefix:val:suffix"
        self.assertEqual(op, "prefix:val:suffix")

    @no_type_check
    @elixir_pipe
    def test_keyword_placeholder_complex(self) -> None:
         # Test with expression
        op = 10 >> my_func(b=20, a=_ + 5)
        # Should become my_func(b=20, a=15) -> "15-20"
        self.assertEqual(op, "15-20")
