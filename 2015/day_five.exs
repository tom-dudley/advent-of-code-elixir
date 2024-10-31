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

  def chars_next_to_each_other(remaining, current_char, next_char)
      when current_char == next_char do
    true
  end

  def chars_next_to_each_other(remaining, current_char, next_char)
      when length(remaining) < 2 do
    false
  end

  def chars_next_to_each_other([head | rest], current_char, next_char) do
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
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_five.txt")
  |> File.read!()

IO.puts(DayFive.partone(input))
# IO.puts(DayFive.parttwo(input))
