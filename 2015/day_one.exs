defmodule DayOne do
  def partone(input) do
    input
    |> directions()
    |> Enum.sum()
  end

  def parttwo(input) do
    input
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
end

instructions =
  File.cwd!()
  |> Path.join("2015/inputs/day_one.txt")
  |> File.read!()

IO.puts(DayOne.partone(instructions))
IO.puts(DayOne.parttwo(instructions))
