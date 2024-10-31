defmodule DayFour do
  def partone(input) do
    input
    |> String.trim()
    |> calc_hash(0, "")
  end

  def parttwo(input) do
    input
    |> String.trim()
    |> calc_hash_parttwo(0, "")
  end

  def calc_hash(key, current_num, current_hash) when binary_part(current_hash, 0, 5) == "00000" do
    current_num
  end

  def calc_hash(key, current_num, current_hash) do
    next_num = current_num + 1
    next_hash = :crypto.hash(:md5, key <> "#{next_num}") |> Base.encode16()
    calc_hash(key, next_num, next_hash)
  end

  def calc_hash_parttwo(key, current_num, current_hash)
      when binary_part(current_hash, 0, 6) == "000000" do
    current_num
  end

  def calc_hash_parttwo(key, current_num, current_hash) do
    next_num = current_num + 1
    next_hash = :crypto.hash(:md5, key <> "#{next_num}") |> Base.encode16()
    calc_hash_parttwo(key, next_num, next_hash)
  end
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_four.txt")
  |> File.read!()

IO.puts(DayFour.partone(input))
IO.puts(DayFour.parttwo(input))
