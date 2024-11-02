# Note: This is very slow and inefficient, but does work 
defmodule AdventOfCode2015.DaySix do
  def partone do
    grid = build_grid(:off)

    commands =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_command(x) end)

    execute_all_commands(commands, grid, &partone_algorithm/3)
    |> Map.values()
    |> Enum.count(fn x -> x == :on end)
  end

  def parttwo do
    grid = build_grid(0)

    commands =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_command(x) end)

    execute_all_commands(commands, grid, &parttwo_algorithm/3)
    |> Map.values()
    |> Enum.sum()
  end

  def build_grid(initial) do
    0..999
    |> Enum.flat_map(fn x ->
      0..999
      |> Enum.map(fn y -> {x, y} end)
    end)
    |> Map.from_keys(initial)
  end

  def execute_all_commands(commands, grid, _algorithm) when length(commands) == 0 do
    grid
  end

  def execute_all_commands([command | rest], grid, algorithm) do
    grid = execute_single_command(command, grid, algorithm)
    execute_all_commands(rest, grid, algorithm)
  end

  def execute_single_command({command, [{x1, y1}, {x2, y2}]}, grid, algorithm) do
    IO.puts("Executing single command")

    coords =
      x1..x2
      |> Enum.flat_map(fn x ->
        y1..y2
        |> Enum.map(fn y -> {x, y} end)
      end)

    execute_single_command_for_coord(command, coords, grid, algorithm)
  end

  def execute_single_command_for_coord(_command, remaining, grid, _algorithm)
      when length(remaining) == 0 do
    grid
  end

  def execute_single_command_for_coord(command, [coord | rest], grid, algorithm) do
    grid = algorithm.(command, coord, grid)
    execute_single_command_for_coord(command, rest, grid, algorithm)
  end

  def partone_algorithm(command, coord, grid) do
    case command do
      :on ->
        Map.put(grid, coord, :on)

      :off ->
        Map.put(grid, coord, :off)

      :toggle ->
        case Map.get(grid, coord) do
          :on -> Map.put(grid, coord, :off)
          :off -> Map.put(grid, coord, :on)
        end
    end
  end

  def parttwo_algorithm(command, coord, grid) do
    case command do
      :on ->
        current_value = Map.get(grid, coord)
        new_value = current_value + 1
        Map.put(grid, coord, new_value)

      :off ->
        current_value = Map.get(grid, coord)
        new_value = current_value - 1

        if new_value < 0 do
          Map.put(grid, coord, 0)
        else
          Map.put(grid, coord, new_value)
        end

      :toggle ->
        current_value = Map.get(grid, coord)
        new_value = current_value + 2
        Map.put(grid, coord, new_value)
    end
  end

  def parse_command("turn on " <> rest), do: parse_coords(:on, rest)
  def parse_command("toggle " <> rest), do: parse_coords(:toggle, rest)
  def parse_command("turn off " <> rest), do: parse_coords(:off, rest)

  def parse_coords(command, coords_text) do
    {command,
     String.split(coords_text, " through ")
     |> Enum.map(fn c ->
       c
       |> String.split(",")
       |> Enum.map(fn x -> String.to_integer(x) end)
       |> List.to_tuple()
     end)}
  end

  defp load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_six.txt")
    |> File.read!()
  end
end
