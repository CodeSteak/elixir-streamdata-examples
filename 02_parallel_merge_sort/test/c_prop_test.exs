defmodule PropTest do
  use ExUnit.Case
  use ExUnitProperties

  property "order of mergesort" do
    check all(list <- list_of(integer(), initial_size: 2)) do
      result = Sort.merge_sort(list)

      Enum.each(0..(length(list) - 2), fn i ->
        assert Enum.at(result, i) <= Enum.at(result, i + 1)
      end)
    end
  end
end
