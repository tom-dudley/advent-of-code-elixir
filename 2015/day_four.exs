defmodule DayFour do
  def partone(input) do
    input
    |> String.trim()
    |> calc_hash(0, "", 5)
  end

  def parttwo(input) do
    input
    |> String.trim()
    |> calc_hash(0, "", 6)
  end

  def calc_hash(key, current_num, current_hash, prefix_zeroes) do
    desired_prefix = String.duplicate("0", prefix_zeroes)

    case String.length(current_hash) >= prefix_zeroes and
           binary_part(current_hash, 0, prefix_zeroes) do
      ^desired_prefix ->
        current_num

      _ ->
        next_num = current_num + 1
        next_hash = :crypto.hash(:md5, key <> "#{next_num}") |> Base.encode16()
        calc_hash(key, next_num, next_hash, prefix_zeroes)
    end
  end
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_four.txt")
  |> File.read!()

IO.puts(DayFour.partone(input))
IO.puts(DayFour.parttwo(input))
