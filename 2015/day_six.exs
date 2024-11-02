defmodule DaySix do
  def partone(input) do
    grid = build_grid()

    IO.puts("Built grid")

    commands =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_command(x) end)

    IO.puts("Parsed commands")

    execute_all_commands(commands, grid)
    |> Map.values()
    |> Enum.count(fn x -> x == :on end)
  end

  def build_grid() do
    0..999
    |> Enum.flat_map(fn x ->
      0..999
      |> Enum.map(fn y -> {x, y} end)
    end)
    |> Map.from_keys(:off)
  end

  def execute_all_commands(commands, grid) when length(commands) == 0 do
    grid
  end

  def execute_all_commands([command | rest], grid) do
    grid = execute_single_command(command, grid)
    execute_all_commands(rest, grid)
  end

  def execute_single_command({command, [{x1, y1}, {x2, y2}]}, grid) do
    IO.puts("Executing single command")

    coords =
      x1..x2
      |> Enum.flat_map(fn x ->
        y1..y2
        |> Enum.map(fn y -> {x, y} end)
      end)

    execute_single_command_for_coord(command, coords, grid)
  end

  def execute_single_command_for_coord(_command, remaining, grid) when length(remaining) == 0 do
    grid
  end

  def execute_single_command_for_coord(command, [coord | rest], grid) do
    grid =
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

    execute_single_command_for_coord(command, rest, grid)
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
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_six.txt")
  |> File.read!()

IO.puts(DaySix.partone(input))
# IO.puts(DaySix.parttwo(input))
