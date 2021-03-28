defmodule NavigatorTest do
  use ExUnit.Case
  doctest Navigator

  test "greets the world" do
    assert Navigator.hello() == :world
  end
end
