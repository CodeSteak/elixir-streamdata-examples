defmodule AgainstStdSortTest do
  use ExUnit.Case
  use ExUnitProperties

  property "mergesort is simular to enum.sort" do
    check all(list <- list_of(integer())) do
      assert Sort.merge_sort(list) == Enum.sort(list)
    end
  end
end
