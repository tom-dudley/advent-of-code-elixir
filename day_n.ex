defmodule AdventOfCode2015.DayN do
  def partone() do
    load()
    |> String.split("\n", trim: true)
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_N.txt")
    |> File.read!()
  end
end
