defmodule DayTwo do
  def partone(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn dimensions ->
      # The following gives a list of [l, w, h]
      [l, w, h] =
        String.split(dimensions, "x")
        |> Enum.map(&String.to_integer/1)

      area = 2 * l * w + 2 * w * h + 2 * h * l
      min_side = Enum.min([l * w, w * h, h * l])
      area + min_side
    end)
    |> Enum.sum()
  end

  def parttwo(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn dimensions ->
      # The following gives a list of [l, w, h]
      [l, w, h] =
        String.split(dimensions, "x")
        |> Enum.map(&String.to_integer/1)

      smallest_perimiter =
        Enum.min([
          2 * l + 2 * w,
          2 * w + 2 * h,
          2 * h + 2 * l
        ])

      smallest_perimiter + l * w * h
    end)
    |> Enum.sum()
  end
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_two.txt")
  |> File.read!()

IO.puts(DayTwo.partone(input))
IO.puts(DayTwo.parttwo(input))
