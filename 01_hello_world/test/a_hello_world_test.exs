defmodule HelloWorldTest do
  use ExUnit.Case
  use ExUnitProperties

  property "all numbers are below 42" do
    check all(num <- integer()) do
      assert num < 42
    end
  end

  property "all number are below 42 unshrinkable" do
    check all(num <- integer() |> unshrinkable()) do
      assert num < 42
    end
  end
end
