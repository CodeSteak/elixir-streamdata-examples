defmodule ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  def json_string_gen() do
    gen all(text <- string(:ascii)) do
      # No escaping for simplicity. Instead filter for '\"'.
      text |> to_charlist() |> Enum.filter(fn x -> x not in '"' end) |> to_string()
    end
  end

  def whitespace_gen() do
    gen all(ch <- list_of(one_of('\t\n ' |> Enum.map(&constant/1)))) do
      ch |> to_string()
    end
  end

  def simple_gen() do
    one_of([
      integer(),
      float(),
      json_string_gen(),
      StreamData.constant(true),
      StreamData.constant(false),
      StreamData.constant(nil)
    ])
  end

  def value_gen() do
    # StreamData.tree must be used for recusive expressions.
    # Normal recursion leads to an endless loop.

    # `tree` takes an base generator and a function.
    # `leaf` can either generate a base generator value or itself.
    StreamData.tree(simple_gen(), fn leaf ->
      one_of([list_of(leaf), map_of(json_string_gen(), leaf)])
    end)
  end

  def json_data_gen() do
    gen all(
          value <- value_gen(),
          front <- whitespace_gen(),
          whitespace <- list_of(whitespace_gen(), length: length(tokenize(value)))
        ) do
      json =
        value
        |> tokenize()
        |> Enum.zip(whitespace)
        |> Enum.map(fn {a, b} -> a <> b end)
        |> Enum.reduce(front, fn a, b -> b <> a end)

      {value, json}
    end
  end

  # Creates json tokens from elixir value
  def tokenize(true), do: ["true"]
  def tokenize(false), do: ["false"]
  def tokenize(nil), do: ["null"]
  def tokenize(str) when is_binary(str), do: ["\"" <> str <> "\""]
  def tokenize(i) when is_integer(i), do: [to_string(i)]
  def tokenize(f) when is_float(f), do: [to_string(f)]

  def tokenize(lst) when is_list(lst) do
    lst =
      lst
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {value, 0} -> tokenize(value)
        {value, _} -> ["," | tokenize(value)]
      end)

    ["["] ++ lst ++ ["]"]
  end

  def tokenize(map) when is_map(map) do
    map =
      map
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {{key, value}, 0} -> tokenize(key) ++ [":"] ++ tokenize(value)
        {{key, value}, _} -> ["," | tokenize(key) ++ [":"] ++ tokenize(value)]
      end)

    ["{"] ++ map ++ ["}"]
  end

  property "serializing is revertable" do
    check all(data <- json_data_gen()) do
      {value, json} = data
      {parsed, tail} = Parser.parseValue(json)
      assert parsed == value
    end
  end
end
