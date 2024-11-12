defmodule AdventOfCode2015.DayEleven do
  def partone() do
    load()
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> next_valid_password()
  end

  def parttwo() do
    load()
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> next_valid_password()
    |> next_valid_password()
  end

  def next_valid_password(password) do
    next_password = increment_password(password)

    if valid_password(next_password) do
      next_password
    else
      next_valid_password(next_password)
    end
  end

  def valid_password(s) do
    if has_straight(s) and has_two_different_non_overlapping_pairs(s) and
         not contains_confusing_letters(s) do
      true
    else
      false
    end
  end

  def contains_confusing_letters(s) do
    String.contains?(s, "i") or
      String.contains?(s, "o") or
      String.contains?(s, "l")
  end

  # This is adapted from 2015 day five
  # Note that we need to deal with two _different_ non-overlapping pairs
  def has_two_different_non_overlapping_pairs(s) do
    s
    |> indexed_pairs()
    |> pair_count(%{})
    |> Enum.filter(fn {{c1, c2}, _} -> c1 == c2 end)
    |> length() >= 2
  end

  def has_straight(s) do
    indexed_triplets(s)
    |> Enum.filter(fn {c1, c2, c3} ->
      c1 != nil and c2 != nil and c3 != nil
    end)
    |> Enum.filter(fn {c1, c2, c3} ->
      i1 = :binary.first(c1)
      i2 = :binary.first(c2)
      i3 = :binary.first(c3)
      i2 == i1 + 1 and i3 == i1 + 2
    end)
    |> length() > 0
  end

  def indexed_triplets(s) do
    s2 = s |> String.split("", trim: true)

    0..(String.length(s) - 3)
    |> Enum.map(fn x ->
      {
        Enum.at(s2, x),
        Enum.at(s2, x + 1),
        Enum.at(s2, x + 2)
      }
    end)
  end

  def indexed_pairs(s) do
    s2 = s |> String.split("", trim: true)

    # Drop the last index as we want pairs
    0..(String.length(s) - 2)
    |> Enum.map(fn x ->
      # The index of each pair and the pair itself
      {x,
       {
         Enum.at(s2, x),
         Enum.at(s2, x + 1)
       }}
    end)
  end

  def pair_count(remaining, pairs) when length(remaining) == 0 do
    pairs
  end

  def pair_count([{index, pair} | rest], pairs) do
    pairs =
      case Map.get(pairs, pair) do
        nil -> Map.put(pairs, pair, [index])
        x -> Map.put(pairs, pair, [index | x])
      end

    pair_count(rest, pairs)
  end

  def increment_password(password) do
    password
    |> String.split("", trim: true)
    |> Enum.map(fn x -> :binary.first(x) end)
    |> Enum.reverse()
    |> increment_reversed_ints()
    |> Enum.reverse()
    |> to_string()
  end

  def increment_reversed_ints([i | rest]) do
    # 122 is z
    if i == 122 do
      [97 | increment_reversed_ints(rest)]
    else
      [i + 1 | rest]
    end
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_eleven.txt")
    |> File.read!()
  end
end
