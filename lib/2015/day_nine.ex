defmodule AdventOfCode2015.DayNine do
  def partone() do
    {distances, locations} =
      load()
      |> String.split("\n", trim: true)
      |> parse_distances(%{}, [])

    routes = combinations(locations)

    routes
    |> Enum.map(fn x -> get_route_distance(x, distances) |> Enum.sum() end)
    |> Enum.min()
  end

  def get_route_distance(route, distances) do
    0..(length(route) - 2)
    |> Enum.map(fn x ->
      origin = Enum.at(route, x)
      destination = Enum.at(route, x + 1)
      get_distance(origin, destination, distances)
    end)
  end

  def get_distance(origin, destination, distances) do
    Map.get(distances, {origin, destination})
  end

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

  def parse_distances(l, distances, locations) when length(l) == 0 do
    {distances, locations}
  end

  def parse_distances([s | rest], distances, locations) do
    {origin, destination, distance} = parse(s)
    distances = Map.put(distances, {origin, destination}, distance)
    distances = Map.put(distances, {destination, origin}, distance)

    if Enum.member?(locations, origin) do
      parse_distances(rest, distances, locations)
    else
      locations = [origin | locations]

      locations =
        if Enum.member?(locations, destination) do
          locations
        else
          [destination | locations]
        end

      parse_distances(rest, distances, locations)
    end
  end

  def parse(s) do
    parts = String.split(s)
    origin = Enum.at(parts, 0)
    destination = Enum.at(parts, 2)
    distance = String.to_integer(Enum.at(parts, 4))
    {origin, destination, distance}
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_nine.txt")
    |> File.read!()
  end
end
