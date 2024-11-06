defmodule AdventOfCode2015.DayEight do
  def partone() do
    load()
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      {String.length(s),
       (s |> String.split("") |> parse_code_to_decoded("") |> String.length()) - 2}
    end)
    |> Enum.reduce(0, fn {chars_in_code, chars_in_memory}, acc ->
      acc + chars_in_code - chars_in_memory
    end)
  end

  def parttwo() do
    load()
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      {(s |> String.split("") |> parse_code_to_encoded("") |> String.length()) + 2,
       String.length(s)}
    end)
    |> Enum.reduce(0, fn {chars_encoded, chars_in_code}, acc ->
      acc + chars_encoded - chars_in_code
    end)
  end

  def parse_code_to_decoded(s, parsed) when length(s) == 0 do
    parsed
  end

  def parse_code_to_decoded([c | rest], parsed) do
    if c == "\\" do
      {c, rest} =
        case Enum.at(rest, 0) do
          "\\" ->
            {"\\", Enum.take(rest, 1 - length(rest))}

          "\"" ->
            {"\"", Enum.take(rest, 1 - length(rest))}

          _ ->
            hex = Enum.slice(rest, 1, 2)
            c = :binary.decode_hex(hex |> Enum.join(""))
            {c, Enum.take(rest, 3 - length(rest))}
        end

      parse_code_to_decoded(rest, parsed <> c)
    else
      parse_code_to_decoded(rest, parsed <> c)
    end
  end

  def parse_code_to_encoded(s, parsed) when length(s) == 0 do
    parsed
  end

  def parse_code_to_encoded([c | rest], parsed) do
    parsed =
      case c do
        "\\" ->
          parsed <> "\\\\"

        "\"" ->
          parsed <> "\\\""

        _ ->
          parsed <> c
      end

    parse_code_to_encoded(rest, parsed)
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_eight.txt")
    |> File.read!()
  end
end
