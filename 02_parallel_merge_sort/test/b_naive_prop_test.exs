defmodule NaivePropTest do
  use ExUnit.Case
  use ExUnitProperties

  property "order of mergesort" do
    check all(
            list <- list_of(integer()),
            a <- integer(0..length(list)),
            b <- integer(0..length(list)),
            a < b
          ) do
      result = Sort.merge_sort(list)
      assert Enum.at(result, a) <= Enum.at(result, b)
    end
  end
end
