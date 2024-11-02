defmodule AdventOfCode2015.DayOne do
  def partone do
    load()
    |> directions()
    |> Enum.sum()
  end

  def parttwo do
    load()
    |> directions()
    |> step(0, 0)
  end

  defp directions(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(fn x ->
      case x do
        "(" -> 1
        ")" -> -1
      end
    end)
  end

  defp step(_rest, position, current_floor) when current_floor == -1 do
    position
  end

  defp step([direction | rest], position, current_floor) do
    step(rest, position + 1, current_floor + direction)
  end

  defp load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_one.txt")
    |> File.read!()
  end
end
