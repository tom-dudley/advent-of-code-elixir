defmodule AdventOfCode2015.DayTen do
  def partone() do
    l = loadlist()
    iterate(l, 40) |> length()
  end

  def parttwo() do
    l = loadlist()
    iterate(l, 50) |> length()
  end

  def loadlist() do
    load()
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> String.split("", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def iterate(l, count) when count == 0 do
    l
  end

  def iterate(l, count) do
    next_iteration = parse(l)
    iterate(next_iteration, count - 1)
  end

  def parse(l) do
    p = l |> Enum.reduce({0, 0, []}, &parse_partial/2)

    parse_partial(0, p)
    |> elem(2)
    |> List.flatten()
    |> Enum.reverse()
    |> tl
    |> tl
  end

  def parse_partial(x, {count, token, partial}) do
    if token == x do
      {count + 1, x, partial}
    else
      {1, x, [[token, count] | partial]}
    end
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_ten.txt")
    |> File.read!()
  end
end
