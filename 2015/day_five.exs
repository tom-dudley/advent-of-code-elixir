defmodule DayFive do
  def partone(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn x ->
      vowel_count(x) >= 3 &&
        chars_next_to_each_other(x) &&
        !contains_forbidden_words(x)
    end)
    |> Enum.count()
  end

  def parttwo(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn x ->
      has_two_non_overlapping_pairs(x) &&
        has_repeating_character_with_spacer(x)
    end)
    |> Enum.count()
  end

  def vowel_count(s) do
    s
    |> String.split("", trim: true)
    |> Enum.map(fn c ->
      case c do
        "a" -> true
        "e" -> true
        "i" -> true
        "o" -> true
        "u" -> true
        _ -> false
      end
    end)
    |> Enum.filter(fn x -> x end)
    |> Enum.count()
  end

  def chars_next_to_each_other(_remaining, current_char, next_char)
      when current_char == next_char do
    true
  end

  def chars_next_to_each_other(remaining, _current_char, _next_char)
      when length(remaining) < 2 do
    false
  end

  def chars_next_to_each_other([_head | rest], _current_char, next_char) do
    current_char = next_char
    next_char = Enum.at(rest, 0)
    chars_next_to_each_other(rest, current_char, next_char)
  end

  def chars_next_to_each_other(s) do
    [head | rest] =
      s
      |> String.split("", trim: true)

    current_char = head
    next_char = Enum.at(rest, 0)
    chars_next_to_each_other(rest, current_char, next_char)
  end

  def contains_forbidden_words(s) do
    String.contains?(s, "ab") ||
      String.contains?(s, "cd") ||
      String.contains?(s, "pq") ||
      String.contains?(s, "xy")
  end

  def has_two_non_overlapping_pairs(s) do
    s
    |> indexed_pairs()
    |> pair_count(%{})
    |> Enum.map(fn {_, l} ->
      {min, max} = Enum.min_max(l)
      # Check that the first and last occurrence are at least two characters apart
      max - min > 1
    end)
    |> Enum.any?()
  end

  def has_repeating_character_with_spacer(s) do
    s
    |> indexed_chars()
    |> char_count(%{})
    |> Enum.map(fn {_, l} ->
      Enum.sort(l)
      |> calc_gaps()
      |> Enum.any?(fn x -> x == 2 end)
    end)
    |> Enum.any?()
  end

  def calc_gaps(remaining, gaps \\ [])

  def calc_gaps(remaining, gaps) when length(remaining) <= 1 do
    gaps
  end

  def calc_gaps([current | rest], gaps) do
    [next | _] = rest
    gaps = [next - current | gaps]
    calc_gaps(rest, gaps)
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

  def indexed_chars(s) do
    s2 = s |> String.split("", trim: true)

    0..(String.length(s) - 1)
    |> Enum.map(fn x ->
      # The index of each char and the char itself
      {x, Enum.at(s2, x)}
    end)
  end

  def char_count(remaining, chars) when length(remaining) == 0 do
    chars
  end

  def char_count([{index, char} | rest], chars) do
    chars =
      case Map.get(chars, char) do
        nil -> Map.put(chars, char, [index])
        x -> Map.put(chars, char, [index | x])
      end

    char_count(rest, chars)
  end
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_five.txt")
  |> File.read!()

IO.puts(DayFive.partone(input))
IO.puts(DayFive.parttwo(input))
