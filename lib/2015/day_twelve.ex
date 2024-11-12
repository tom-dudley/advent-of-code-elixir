defmodule AdventOfCode2015.DayTwelve do
  def partone() do
    {:ok, j} = load() |> JSON.decode()

    j
    |> List.flatten()
    |> get_ints()
    |> Enum.sum()
  end

  def parttwo() do
    {:ok, j} = load() |> JSON.decode()

    j
    |> List.flatten()
    |> get_ints_without_red()
    |> Enum.sum()
  end

  def get_ints_without_red(val) when is_integer(val) do
    [val]
  end

  def get_ints_without_red(l) when is_list(l) do
    l
    |> Enum.map(fn x -> get_ints_without_red(x) end)
    |> List.flatten()
  end

  def get_ints_without_red(m) when is_map(m) do
    map_values = m |> Map.values()

    if Enum.member?(map_values, "red") do
      []
    else
      map_values
      |> Enum.map(fn x -> get_ints_without_red(x) end)
      |> List.flatten()
    end
  end

  def get_ints_without_red(s) when is_binary(s) do
    []
  end

  def get_ints(val) when is_integer(val) do
    [val]
  end

  def get_ints(l) when is_list(l) do
    l
    |> Enum.map(fn x -> get_ints(x) end)
    |> List.flatten()
  end

  def get_ints(m) when is_map(m) do
    m
    |> Map.values()
    |> Enum.map(fn x -> get_ints(x) end)
    |> List.flatten()
  end

  def get_ints(s) when is_binary(s) do
    []
  end

  # def count_ints(m, total) when is_map(val) do
  #   Map.values(val)
  #   |> 
  # end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_twelve.txt")
    |> File.read!()
  end
end
