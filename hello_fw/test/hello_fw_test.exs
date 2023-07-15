defmodule HelloFwTest do
  use ExUnit.Case
  doctest HelloFw

  test "greets the world" do
    assert HelloFw.hello() == :world
  end
end
