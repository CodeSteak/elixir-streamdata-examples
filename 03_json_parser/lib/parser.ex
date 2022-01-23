defmodule Parser do
  # whitespace
  def parseValue(<<h::utf8>> <> tail) when h <= 32 do
    parseValue(tail)
  end

  # String (no escaping supported)
  def parseValue("\"" <> tail = input) do
    parseString(input)
  end

  # Number
  def parseValue(<<h::utf8>> <> _ = input) when h in '-0123456789' do
    # try both, prefer longer, than int.
    i = Integer.parse(input)
    f = Float.parse(input)

    case {i, f} do
      {:error, f} -> f
      {{_, it}, {f, ft}} when byte_size(ft) < byte_size(it) -> {f, ft}
      {{i, it}, _} -> {i, it}
    end
  end

  # Object
  def parseValue("{" <> tail) do
    parseObjectKeyValuePair(tail)
  end

  # Array
  def parseValue("[" <> tail) do
    parseArrayValue(tail)
  end

  # Consts
  def parseValue("true" <> tail) do
    {true, tail}
  end

  def parseValue("false" <> tail) do
    {false, tail}
  end

  def parseValue("null" <> tail) do
    {nil, tail}
  end

  def parseString("\"" <> tail) do
    str = tail |> to_charlist |> Enum.take_while(fn char -> char not in '"' end) |> to_string()

    # Split
    "\"" <> tail = binary_part(tail, byte_size(str), byte_size(tail) - byte_size(str))

    {str, tail}
  end

  # trim whitespace
  def parseObjectKeyValuePair(<<h::utf8>> <> tail) when h <= 32, do: parseObjectKeyValuePair(tail)
  # empty
  def parseObjectKeyValuePair("}" <> tail), do: {%{}, tail}
  # comma separated
  def parseObjectKeyValuePair(input) do
    {key, tail} = parseString(input)
    ":" <> tail = String.trim_leading(tail)
    {value, tail} = parseValue(tail)

    case String.trim_leading(tail) do
      "," <> tail ->
        {next, tail} = parseObjectKeyValuePair(tail)
        {Map.merge(%{key => value}, next), tail}

      "}" <> tail ->
        {%{key => value}, tail}
    end
  end

  # trim whitespace
  def parseArrayValue(<<h::utf8>> <> tail) when h <= 32, do: parseArrayValue(tail)
  # empty
  def parseArrayValue("]" <> tail), do: {[], tail}
  # comma separated
  def parseArrayValue(input) do
    {v, tail} = parseValue(input)

    case String.trim_leading(tail) do
      "," <> tail ->
        {next, tail} = parseArrayValue(tail)
        {[v | next], tail}

      "]" <> tail ->
        {[v], tail}
    end
  end
end
