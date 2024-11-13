defmodule AdventOfCode2015.DayFourteen do
  def partone() do
    race_duration = 2503

    load()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.map(fn reindeer ->
      d = calculate_distance(reindeer, race_duration)

      # assert that the length matches the number of seconds in the race
      ^race_duration =
        length(d)

      d |> List.last()
    end)
    |> Enum.max()
  end

  def parttwo() do
    race_duration = 2503

    reindeers =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(&parse/1)

    distances =
      reindeers
      |> Enum.map(fn reindeer ->
        d = calculate_distance(reindeer, race_duration)
        # assert that the length matches the number of seconds in the race
        ^race_duration = length(d)
        d
      end)

    distances
    |> Enum.zip()
    |> Enum.reduce(
      List.duplicate(0, length(reindeers)),
      fn x, scores ->
        l = Tuple.to_list(x)
        m = Enum.max(l)

        0..(length(reindeers) - 1)
        |> Enum.map(fn x ->
          if Enum.at(l, x) == m do
            Enum.at(scores, x) + 1
          else
            Enum.at(scores, x)
          end
        end)
      end
    )
    |> Enum.max()
  end

  def calculate_distance(reindeer, race_duration) do
    step(reindeer, [], 0, race_duration, :flying)
  end

  def step(_reindeer, distance_covered_by_second, duration, race_duration, _state)
      when duration >= race_duration do
    distance_covered_by_second
  end

  def step(reindeer, distance_covered_by_second, duration, race_duration, :flying) do
    fly_speed = reindeer |> elem(1) |> Map.get(:fly_speed)
    fly_duration = reindeer |> elem(1) |> Map.get(:fly_duration)

    current_distance =
      case List.last(distance_covered_by_second) do
        nil ->
          0

        x ->
          x
      end

    if duration + fly_duration >= race_duration do
      time_left = race_duration - duration
      fly_duration = time_left

      new_distances =
        1..fly_duration
        |> Enum.map(fn x -> x * fly_speed + current_distance end)

      distance_covered_by_second = Enum.concat(distance_covered_by_second, new_distances)
      duration = duration + fly_duration
      step(reindeer, distance_covered_by_second, duration, race_duration, :resting)
    else
      new_distances =
        1..fly_duration
        |> Enum.map(fn x -> x * fly_speed + current_distance end)

      distance_covered_by_second = Enum.concat(distance_covered_by_second, new_distances)
      duration = duration + fly_duration
      step(reindeer, distance_covered_by_second, duration, race_duration, :resting)
    end
  end

  def step(reindeer, distance_covered_by_second, duration, race_duration, :resting) do
    current_distance = List.last(distance_covered_by_second)
    rest_duration = reindeer |> elem(1) |> Map.get(:rest_duration)

    if duration + rest_duration >= race_duration do
      time_left = race_duration - duration
      rest_duration = time_left

      new_distances = List.duplicate(current_distance, rest_duration)

      distance_covered_by_second = Enum.concat(distance_covered_by_second, new_distances)
      duration = duration + rest_duration
      step(reindeer, distance_covered_by_second, duration, race_duration, :flying)
    else
      new_distances = List.duplicate(current_distance, rest_duration)

      distance_covered_by_second = Enum.concat(distance_covered_by_second, new_distances)
      duration = duration + rest_duration
      step(reindeer, distance_covered_by_second, duration, race_duration, :flying)
    end
  end

  def parse(s) do
    parts = s |> String.split()
    name = Enum.at(parts, 0)
    fly_speed = Enum.at(parts, 3) |> String.to_integer()
    fly_duration = Enum.at(parts, 6) |> String.to_integer()
    rest_duration = Enum.at(parts, 13) |> String.to_integer()

    {name,
     %{
       fly_speed: fly_speed,
       fly_duration: fly_duration,
       rest_duration: rest_duration
     }}
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_fourteen.txt")
    |> File.read!()
  end
end
