defmodule Lecture2Test do
  use ExUnit.Case
  doctest Lecture2

  test "greets the world" do
    assert Lecture2.hello() == :world
  end
end
