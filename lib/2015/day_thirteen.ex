import Combinatorics

# NOTE: This is very similar to day 9
defmodule AdventOfCode2015.DayThirteen do
  def partone() do
    {happinesses, people} =
      load()
      |> String.split("\n", trim: true)
      |> parse_happiness(%{}, [])

    arrangements = combinations(people)

    arrangements
    |> Enum.map(fn x -> get_total_happiness(x, happinesses) |> Enum.sum() end)
    |> Enum.max()
  end

  def parttwo() do
    {happinesses, people} =
      load()
      |> String.split("\n", trim: true)
      |> parse_happiness(%{}, [])

    happinesses =
      people
      |> Enum.reduce(happinesses, fn person, happinesses ->
        happinesses = Map.put(happinesses, {"Me", person}, 0)
        happinesses = Map.put(happinesses, {person, "Me"}, 0)
        happinesses
      end)

    people = ["Me" | people]

    arrangements = combinations(people)

    arrangements
    |> Enum.map(fn x -> get_total_happiness(x, happinesses) |> Enum.sum() end)
    |> Enum.max()
  end

  def get_total_happiness(arrangement, happinesses) do
    arrangement_happiness =
      0..(length(arrangement) - 2)
      |> Enum.map(fn x ->
        from = Enum.at(arrangement, x)
        to = Enum.at(arrangement, x + 1)

        # Consider happiness of A sitting next to B, and B sitting next to A
        get_happiness(from, to, happinesses) +
          get_happiness(to, from, happinesses)
      end)

    # Consider happiness of A sitting next to the last person, and vice versa
    from = List.first(arrangement)
    to = List.last(arrangement)
    arrangement_happiness = [get_happiness(from, to, happinesses) | arrangement_happiness]
    arrangement_happiness = [get_happiness(to, from, happinesses) | arrangement_happiness]

    arrangement_happiness
  end

  def get_happiness(from, to, happinesses) do
    Map.get(happinesses, {from, to})
  end

  def parse_happiness(l, scores, people) when length(l) == 0 do
    {scores, people}
  end

  def parse_happiness([s | rest], happinesses, people) do
    {from, to, happiness} = parse(s)
    happinesses = Map.put(happinesses, {from, to}, happiness)

    if Enum.member?(people, from) do
      parse_happiness(rest, happinesses, people)
    else
      people = [from | people]

      people =
        if Enum.member?(people, to) do
          people
        else
          [to | people]
        end

      parse_happiness(rest, happinesses, people)
    end
  end

  def parse(s) do
    parts =
      s
      |> String.trim(".")
      |> String.split()

    from = Enum.at(parts, 0)
    to = Enum.at(parts, 10)
    happiness = Enum.at(parts, 3) |> String.to_integer()

    case Enum.at(parts, 2) do
      "lose" ->
        {from, to, -1 * happiness}

      "gain" ->
        {from, to, happiness}
    end
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_thirteen.txt")
    |> File.read!()
  end
end
