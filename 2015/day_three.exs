defmodule DayThree do
  def partone(input) do
    movements = get_movements(input)
    move(movements, {0, 0}, %{}) |> map_size()
  end

  def parttwo(input) do
    santa_movements =
      input
      |> get_movements()
      |> Enum.take_every(2)

    # Take the tail to offset by one
    robo_movements =
      input
      |> get_movements
      |> tl
      |> Enum.take_every(2)

    santa_visits = move(santa_movements, {0, 0}, %{})
    robo_visits = move(robo_movements, {0, 0}, %{})

    Map.merge(santa_visits, robo_visits) |> map_size()
  end

  defp get_movements(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(fn x ->
      case x do
        "^" -> {1, 0}
        "<" -> {0, -1}
        ">" -> {0, 1}
        "v" -> {-1, 0}
      end
    end)
  end

  defp move(movements, _current_position, visited_coords) when length(movements) == 0 do
    visited_coords
  end

  defp move([{move_x, move_y} | remaining], {current_x, current_y}, visited_coords) do
    new_pos = {current_x + move_x, current_y + move_y}

    move(
      remaining,
      new_pos,
      Map.put(visited_coords, new_pos, :visited)
    )
  end
end

input =
  File.cwd!()
  |> Path.join("2015/inputs/day_three.txt")
  |> File.read!()

IO.puts(DayThree.partone(input))
IO.puts(DayThree.parttwo(input))
