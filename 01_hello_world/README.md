# Hello World

This tries to give a short overview of **StreamData** and a base line for 
starting projects.


## Creation

To create a new project, elixir's built-in project manager `mix` can be used.
```bash
mix new hello_world
```

A new project file `mix.exs` is created. It is an runnable elixir file, that 
describes various properties like application name or used language version in 
return values of functions.

Dependencies are returned by the `deps`-function. 
Since StreamData is not bundled with elixir it has to be added like so:
```elixir
defp deps do
  [
    {:stream_data, "~> 0.5"},
  ]
end
```

Then dependencies have to be downloaded using `mix`.
```bash
mix deps.get
```

A REPL can be run using
```bash
iex -S mix
```


## Adding Tests

Elixir's built-in testing framework is called ExUnit. StreamData is designed to
be used within it.

Tests are located in the `test` directory, separated into modules. On creation a 
first test is already generated.

```elixir
defmodule HelloWorldTest do
  use ExUnit.Case

  test "greets the world" do
    assert HelloWorld.hello() == :world
  end
end
```

To include StreamData the following line has to be inserted at the top of each
module:

```elixir
  use ExUnitProperties
```

Then a macro for writing property-based tests can be used:

```elixir
  property "all numbers are below 42" do
    check all num <- integer() do
      assert num < 42
    end
  end
```


## Running

Tests can be run like so:
```bash
mix test
```
**Note:** all test files must end with `_test.exs` to be discoverd.

`--cover` can be added to also get line coverage.

Of course the test above will fail, as numbers can be larger than `42`.
```
  1) property all numbers are below 42 (HelloWorldTest)
     test/a_hello_world_test.exs:5
     Failed with generated values (after 49 successful runs):
     
         * Clause:    num <- integer()
           Generated: 42
     
     Assertion with < failed, both sides are exactly equal
     code: assert num < 42
     left: 42
     stacktrace:
       test/a_hello_world_test.exs:7: anonymous fn/2 in HelloWorldTest."property all numbers are below 42"/1
       (stream_data 0.5.0) lib/stream_data.ex:2148: StreamData.shrink_failure/6
       (stream_data 0.5.0) lib/stream_data.ex:2108: StreamData.check_all/7
       test/a_hello_world_test.exs:6: (test)
```

StreamData will generate random values for testing. The values get "larger" 
over time. Per default 100 values are tested. On failure StreamData will 
automatically search for the "smallest" value that fails the property. This done
by creating "smaller" permutations and retrying. This is called __shrinking__.
Here the smallest values that is not bellow `42` is `42`, so it is found.

How each value type is shrunk and which generators are available can be found 
in the documentation of StreamData.

Values can also be marked as `unshrinkable`. 
```elixir
  property "all number are below 42, unshrinkable" do
    check all num <- integer() |> unshrinkable() do
      assert num < 42
    end
  end
```
```
  2) property all number are below 42, unshrinkable (HelloWorldTest)
     test/a_hello_world_test.exs:11
     Failed with generated values (after 49 successful runs):
     
         * Clause:    num <- integer() |> unshrinkable()
           Generated: 46
     
     Assertion with < failed
     code:  assert num < 42
     left:  46
     right: 42
     stacktrace:
       test/a_hello_world_test.exs:13: anonymous fn/2 in HelloWorldTest."property all number are below 42 unshrinkable"/1
       (stream_data 0.5.0) lib/stream_data.ex:2102: StreamData.check_all/7
       test/a_hello_world_test.exs:12: (test)
```


## Value Generation

StreamData has the concept of Generators. For all basic types these are already 
provided and can be combined for more complex data. Operations like `map`,
`filter` or `zip` are possible.

A list of integers can be created like this:
```elixir
StreamData.list_of(StreamData.integer()) |> Enum.take(10)

>   [
      [1],
      [-2, -2],
      [-2, 3, 2],
      [3, -1],
      [2, 0, 0],
      [],
      [6, -4, 7, 5, 3, -7],
      [5, -1, -8, 3, 2, 7, -2],
      [-6, 9, -3, 9],
      [-10, 0, -2, 10, 2, 3, -10, 8, -3, -8]
    ]
```
**Note:** These generators also implement `Enum`. So `Enum.take` can be used to 
generate data in the REPL. However in tests, only functions provided by 
`StreamData` should be used.

Here it can be seen how integers have a larger amplitude and lists get longer 
with each generated value.

More complex data generation is shown in the other examples.








