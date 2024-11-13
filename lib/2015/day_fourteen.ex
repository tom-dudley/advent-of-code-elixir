defmodule AdventOfCode2015.DayFourteen do
  def partone() do
    race_duration = 2503

    load()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> race(race_duration)
  end

  def race(reindeers, race_duration) do
    reindeers
    |> Enum.map(fn reindeer ->
      calculate_distance(reindeer, race_duration)
    end)
    |> Enum.max()
  end

  def calculate_distance(reindeer, race_duration) do
    step(reindeer, 0, 0, race_duration, :flying)
  end

  def step(_reindeer, distance_covered, duration, race_duration, _state)
      when duration >= race_duration do
    distance_covered
  end

  def step(reindeer, distance_covered, duration, race_duration, :flying) do
    fly_speed = reindeer |> elem(1) |> Map.get(:fly_speed)
    fly_duration = reindeer |> elem(1) |> Map.get(:fly_duration)

    if duration + fly_duration >= race_duration do
      time_left = race_duration - duration
      distance_covered = distance_covered + fly_speed * time_left
      duration = duration + fly_duration
      step(reindeer, distance_covered, duration, race_duration, :resting)
    else
      distance_covered = distance_covered + fly_speed * fly_duration
      duration = duration + fly_duration
      step(reindeer, distance_covered, duration, race_duration, :resting)
    end
  end

  def step(reindeer, distance_covered, duration, race_duration, :resting) do
    rest_duration = reindeer |> elem(1) |> Map.get(:rest_duration)
    duration = duration + rest_duration
    step(reindeer, distance_covered, duration, race_duration, :flying)
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
