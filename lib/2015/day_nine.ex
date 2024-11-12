import Combinatorics

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

  def parttwo() do
    {distances, locations} =
      load()
      |> String.split("\n", trim: true)
      |> parse_distances(%{}, [])

    routes = combinations(locations)

    routes
    |> Enum.map(fn x -> get_route_distance(x, distances) |> Enum.sum() end)
    |> Enum.max()
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
