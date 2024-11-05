import AdventOfCode2015.DaySeven

defmodule AdventOfCode2015.DaySevenTest do
  use ExUnit.Case, async: true

  test "parse integer" do
    assert parse_connection("12 -> x") == {{:integer, 12}, {:id, "x"}}
  end

  test "parse id" do
    assert parse_connection("abc -> x") == {{:id, "abc"}, {:id, "x"}}
  end

  test "parse lshift" do
    assert parse_connection("a LSHIFT b -> x") == {
             {:lshift, {:id, "a"}, {:id, "b"}},
             {:id, "x"}
           }
  end

  test "parse rshift" do
    assert parse_connection("a RSHIFT b -> x") == {
             {:rshift, {:id, "a"}, {:id, "b"}},
             {:id, "x"}
           }
  end

  test "parse and" do
    assert parse_connection("a AND b -> x") == {
             {:and, {:id, "a"}, {:id, "b"}},
             {:id, "x"}
           }
  end

  test "evaluate not" do
    connections = [
      {{:integer, 123}, {:id, "x"}},
      {{:not, {:id, "x"}}, {:id, "h"}}
    ]

    assert evaluate({:id, "x"}, connections, %{}) == {123, %{{:id, "x"} => 123}}
    assert evaluate({:id, "h"}, connections, %{}) == {65412, %{{:id, "h"} => 65412}}
  end

  test "parse int" do
    assert parse("5") == {:integer, 5}
  end

  test "parse string" do
    assert parse("ab") == {:id, "ab"}
  end

  test "output to input map" do
  end

  test "basic example" do
    connections =
      [
        "123 -> x",
        "456 -> y",
        "x AND y -> d",
        "x OR y -> e",
        "x LSHIFT 2 -> f",
        "y RSHIFT 2 -> g",
        "NOT x -> h",
        "NOT y -> i"
      ]
      |> Enum.map(fn x -> parse_connection(x) end)

    IO.inspect(connections)

    assert evaluate({:id, "d"}, connections, %{}) == {72, %{{:id, "d"} => 72}}
    assert evaluate({:id, "e"}, connections, %{}) == {507, %{{:id, "e"} => 507}}

    assert evaluate({:id, "f"}, connections, %{}) == {492, %{{:id, "f"} => 492}}

    assert evaluate({:id, "g"}, connections, %{}) == {114, %{{:id, "g"} => 114}}

    assert evaluate({:id, "x"}, connections, %{}) == {123, %{{:id, "x"} => 123}}

    assert evaluate({:id, "y"}, connections, %{}) == {456, %{{:id, "y"} => 456}}

    assert evaluate({:id, "h"}, connections, %{}) == {65412, %{{:id, "h"} => 65412}}

    assert evaluate({:id, "i"}, connections, %{}) == {65079, %{{:id, "i"} => 65079}}
  end

  # test "evaluate and" do
  #   connections = [
  #     {{:integer, 12}, "a"},
  #     {{:integer, 15}, "b"},
  #     {{:integer, 15}, "b"},
  #   ]
  #   assert evaluate({:and, 12, 25}, []) == Bitwise.band(12, 25)
  # end
end
