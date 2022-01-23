# JSON-Parser

This example implements a JSON-Parser. It uses more advanced data generation for 
testing.


## Running

This can be run using:
```bash
mix deps.get
mix test
```

A REPL can be opened after the tests are run:
```bash
iex -S mix test
```


## Generation Sketch

### 1. Serializable data is generated.
```elixir
value = ParserTest.value_gen() |> Enum.take(15) |> List.last()
```
```elixir
%{"" => [false], "wI " => %{"" => "-*m>bTidRyuL3"}, "}" => [%{"K" => true}]}
```

### 2. Tokens are generated to produce valid json.
```elixir
tokens = ParserTest.tokenize(value)
```
```elixir
["{", "\"\"", ":", "[", "false", "]", ",", "\"wI \"", ":", "{", "\"\"", ":",
"\"-*m>bTidRyuL3\"", "}", ",", "\"}\"", ":", "[", "{", "\"K\"", ":", "true",
"}", "]", "}"]
```


### 3. Whitespace is inserted between tokens.
```elixir
front = ParserTest.whitespace_gen() |> Enum.take(1) |> List.last()
between = ParserTest.whitespace_gen() |> Enum.take(length(tokens))

json = tokens
|> Enum.zip(between)
|> Enum.map(fn {a,b} -> a <> b end)
|> Enum.reduce(front, fn a, b -> b <> a end)
```
```json
{"":    [       false      ],      "wI "        :                       {                       "":                                     "-*m>bTidRyuL3"           }                                     ,"}"                            :                       [                        {                      "K"      :                        true                                          }                                       ]                                                }
```

#### 4. The parsed result is compared to the initial serializable data generated.
```elixir
{parsed, _tail} = Parser.parseValue(json)
```
```elixir
%{"" => [false], "wI " => %{"" => "-*m>bTidRyuL3"}, "}" => [%{"K" => true}]}
```

More details are found in code comments.

**Note:** Escape sequences in strings are not implement for simplicity.
