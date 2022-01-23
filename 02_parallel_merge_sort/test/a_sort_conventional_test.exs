defmodule ConventionalTest do
  use ExUnit.Case

  test "test mergesort" do
    assert Sort.merge_sort([]) == []
    assert Sort.merge_sort([3, 1, 2]) == [1, 2, 3]
    assert Sort.merge_sort([7, 2, 4, 3, 6, 5, 8, 1]) == [1, 2, 3, 4, 5, 6, 7, 8]
    assert Sort.merge_sort([4, 3, 2, 1, 1]) == [1, 1, 2, 3, 4]
  end
end
