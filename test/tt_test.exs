defmodule TTTest do
  use ExUnit.Case
  doctest TT

  test "greets the world" do
    assert TT.hello() == :world
  end
end
