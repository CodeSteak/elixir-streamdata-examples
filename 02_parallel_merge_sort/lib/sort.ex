defmodule Sort do
  def merge_sort(list) when length(list) <= 1, do: list

  def merge_sort(list) do
    {left, right} = Enum.split(list, div(length(list), 2))

    left_task = Task.async(fn -> merge_sort(left) end)
    right_task = Task.async(fn -> merge_sort(right) end)

    merge(Task.await(left_task), Task.await(right_task))
  end

  # Intentional BUG: `a == b` is not covered and falls back to 3rd merge,
  # which concatinates instead of merging.
  defp merge([a | left], [b | right]) when a < b, do: [a | merge(left, [b | right])]
  defp merge([a | left], [b | right]) when a > b, do: [b | merge([a | left], right)]
  # left or right empty
  defp merge(left, right), do: left ++ right
end
