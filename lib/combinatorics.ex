defmodule Combinatorics do
  def rotate(l, start_at) do
    len = length(l)
    start_at = rem(start_at, len)

    if start_at == 0 do
      l
    else
      # start_at 1: 0..0, 1..3 [a], [b,c,d] -> [b,c,d,a]
      # start_at 2: 0..1, 2..3 [a,b], [c,d] -> [c,d,a,b]
      # start_at 3: 0..2, 3..3 [a,b,c], [d] -> [d,a,b,c]
      last = l |> Enum.slice(0..(start_at - 1))
      first = l |> Enum.slice(start_at..len)
      Enum.concat(first, last)
    end
  end

  def combinations(l) when length(l) == 0 do
    l
  end

  def combinations(l) when length(l) == 1 do
    l
  end

  def combinations(l) when length(l) == 2 do
    [rotate(l, 0), rotate(l, 1)]
  end

  def combinations(l) do
    rotations = 0..(length(l) - 1) |> Enum.map(fn x -> rotate(l, x) end)

    rotations
    |> Enum.flat_map(fn r ->
      [first | rest] = r
      combinations(rest) |> Enum.map(fn x -> [first | x] end)
    end)
  end
end
