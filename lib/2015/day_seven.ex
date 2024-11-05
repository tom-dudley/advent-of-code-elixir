import Bitwise

defmodule AdventOfCode2015.DaySeven do
  def partone do
    connections =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_connection(x) end)

    evaluated = evaluate_outputs(connections, %{}, connections)

    {wire_a, _evaluated} = evaluate({:id, "a"}, connections, evaluated)
    wire_a
  end

  def parttwo do
    connections =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_connection(x) end)

    evaluated = evaluate_outputs(connections, %{}, connections)

    {wire_a, _evaluated} = evaluate({:id, "a"}, connections, evaluated)

    connections =
      connections |> Enum.filter(fn connection -> elem(connection, 1) != {:id, "b"} end)

    connections = [{{:integer, wire_a}, {:id, "b"}} | connections]

    evaluated = evaluate_outputs(connections, %{}, connections)

    {wire_a, _evaluated} = evaluate({:id, "a"}, connections, evaluated)
    wire_a
  end

  def evaluate_outputs(connections, evaluated, _connections) when length(connections) == 0 do
    evaluated
  end

  def evaluate_outputs([connection | rest], evaluated, connections) do
    id = elem(connection, 1)
    {value, evaluated} = evaluate(id, connections, evaluated)
    evaluated = Map.put(evaluated, id, value)
    evaluate_outputs(rest, evaluated, connections)
  end

  def parse_connection(s) do
    [input, output] = String.split(s, " -> ")

    parsed_input =
      cond do
        match?({_, ""}, Integer.parse(input)) ->
          {:integer, String.to_integer(input)}

        String.contains?(input, " LSHIFT ") ->
          [l, r] = String.split(input, " LSHIFT ", trim: true)
          {:lshift, parse(l), parse(r)}

        String.contains?(input, "NOT ") ->
          [x] = String.split(input, "NOT ", trim: true)
          {:not, parse(x)}

        String.contains?(input, "OR ") ->
          [l, r] = String.split(input, " OR ", trim: true)
          {:or, parse(l), parse(r)}

        String.contains?(input, " AND ") ->
          [l, r] = String.split(input, " AND ", trim: true)
          {:and, parse(l), parse(r)}

        String.contains?(input, " RSHIFT ") ->
          [l, r] = String.split(input, " RSHIFT ", trim: true)
          {:rshift, parse(l), parse(r)}

        true ->
          {:id, input}
      end

    {parsed_input, {:id, output}}
  end

  def parse(s) do
    case Integer.parse(s) do
      {i, _} ->
        {:integer, i}

      :error ->
        {:id, s}
    end
  end

  def get_input_for_output({:integer, i}, _connections) do
    {:integer, i}
  end

  def get_input_for_output({:id, id}, connections) do
    case Enum.filter(
           connections,
           fn x ->
             elem(x, 1) == {:id, id}
           end
         ) do
      nil ->
        raise "Error looking up id: #{id}"

      l ->
        case Enum.at(l, 0) do
          nil -> raise "Error getting input"
          {input, _} -> input
        end
    end
  end

  def get_input_for_output(id, connections) when is_binary(id) do
    get_input_for_output({:id, id}, connections)
  end

  def evaluate({:id, id}, connections, evaluated) do
    if Map.has_key?(evaluated, {:id, id}) do
      {Map.get(evaluated, {:id, id}), evaluated}
    else
      connection = get_input_for_output({:id, id}, connections)
      {value, evaluated} = evaluate(connection, connections, evaluated)
      {value, Map.put(evaluated, {:id, id}, value)}
    end
  end

  def evaluate(operation, connections, evaluated) do
    if Map.has_key?(evaluated, operation) do
      {Map.get(evaluated, operation), evaluated}
    else
      case operation do
        {:lshift, l, r} ->
          {lhs, evaluated} =
            get_input_for_output(l, connections) |> evaluate(connections, evaluated)

          {rhs, evaluated} =
            get_input_for_output(r, connections) |> evaluate(connections, evaluated)

          value = Bitwise.<<<(lhs, rhs)
          evaluated = Map.put(evaluated, {:lshift, l, r}, value)
          {value, evaluated}

        {:rshift, l, r} ->
          {lhs, evaluated} =
            get_input_for_output(l, connections) |> evaluate(connections, evaluated)

          {rhs, evaluated} =
            get_input_for_output(r, connections) |> evaluate(connections, evaluated)

          value = Bitwise.>>>(lhs, rhs)
          evaluated = Map.put(evaluated, {:rshift, l, r}, value)
          {value, evaluated}

        {:and, l, r} ->
          {lhs, evaluated} =
            get_input_for_output(l, connections) |> evaluate(connections, evaluated)

          {rhs, evaluated} =
            get_input_for_output(r, connections) |> evaluate(connections, evaluated)

          value = Bitwise.band(lhs, rhs)
          evaluated = Map.put(evaluated, {:and, l, r}, value)
          {value, evaluated}

        {:or, l, r} ->
          {lhs, evaluated} =
            get_input_for_output(l, connections) |> evaluate(connections, evaluated)

          {rhs, evaluated} =
            get_input_for_output(r, connections) |> evaluate(connections, evaluated)

          value = Bitwise.bor(lhs, rhs)
          evaluated = Map.put(evaluated, {:or, l, r}, value)
          {value, evaluated}

        {:not, x} ->
          {rhs, evaluated} =
            get_input_for_output(x, connections) |> evaluate(connections, evaluated)

          value = Bitwise.bnot(rhs) &&& (1 <<< 16) - 1
          evaluated = Map.put(evaluated, {:not, x}, value)
          {value, evaluated}

        {:integer, x} ->
          value = x
          evaluated = Map.put(evaluated, {:integer, x}, value)
          {value, evaluated}
      end
    end
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_seven.txt")
    |> File.read!()
  end
end
