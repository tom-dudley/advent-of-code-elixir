import Bitwise

defmodule AdventOfCode2015.DaySeven do
  @type integer_input() :: {:integer, integer()}
  @type wire() :: {:id, String.t()}
  @type lshift_gate() :: {:lshift, integer(), integer()}
  @type rshift_gate() :: {:rshift, integer(), integer()}
  @type and_gate() :: {:and, integer(), integer()}
  @type or_gate() :: {:or, integer(), integer()}
  @type not_gate() :: {:not, integer()}
  @type gate() :: lshift_gate() | rshift_gate() | and_gate() | or_gate() | not_gate()
  @type id() :: {:id, String.t()}
  @type connection() :: {integer_input() | wire() | gate(), id()}

  # @spec partone() :: integer()
  def partone do
    connections =
      load()
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> parse_connection(x) end)

    evaluated = evaluate_outputs(connections, %{}, connections)
    evaluated

    # evaluate({:id, "a"}, connections)
  end

  def evaluate_outputs(connections, evaluated, connections) when length(connections) == 0 do
    evaluated
  end

  def evaluate_outputs([connection | rest], evaluated, connections) do
    id = elem(connection, 1)
    id_str = elem(id, 1)
    IO.puts("Evaluating output: #{id_str}")
    value = evaluate(id, connections, evaluated)
    Map.put(evaluated, id, value)
    evaluate_outputs(rest, evaluated, connections)
  end

  # @spec parse_connection(String.t()) :: connection()
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

  # get_input_for_output gets the input into a given provided output 
  @spec get_input_for_output(integer_input(), list(connection())) :: connection()
  def get_input_for_output({:integer, i}, _connections) do
    {:integer, i}
  end

  @spec get_input_for_output(id(), list(connection())) :: connection()
  def get_input_for_output({:id, id}, connections) do
    IO.puts("Looking up id: #{id}")

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

  @spec get_input_for_output(String.t(), list(connection())) :: connection()
  def get_input_for_output(id, connections) when is_binary(id) do
    IO.puts("Looking up by id: #{id}")
    get_input_for_output({:id, id}, connections)
  end

  def evaluate({:id, id}, connections, evaluated) do
    IO.puts("Evaluating by id: #{id}")

    if Map.has_key?(evaluated, {:id, id}) do
      Map.get(evaluated, {:id, id})
    else
      connection = get_input_for_output({:id, id}, connections)
      value = evaluate(connection, connections, evaluated)
      IO.puts("Storing value: #{id}")
      new_evaluated = Map.put(evaluated, {:id, id}, value)
    end
  end

  # @spec evaluate(lshift_gate(), list(connection())) :: integer()
  def evaluate({:lshift, l, r}, connections, evaluated) do
    l_connection = get_input_for_output(l, connections)
    r_connection = get_input_for_output(r, connections)

    Bitwise.<<<(
      evaluate(l_connection, connections, evaluated),
      evaluate(r_connection, connections, evaluated)
    )
  end

  # @spec evaluate(rshift_gate(), list(connection())) :: integer()
  def evaluate({:rshift, l, r}, connections, evaluated) do
    l_connection = get_input_for_output(l, connections)
    r_connection = get_input_for_output(r, connections)

    Bitwise.>>>(
      evaluate(l_connection, connections, evaluated),
      evaluate(r_connection, connections, evaluated)
    )
  end

  # @spec evaluate(and_gate(), list(connection())) :: integer()
  def evaluate({:and, l, r}, connections, evaluated) do
    l_connection = get_input_for_output(l, connections)
    r_connection = get_input_for_output(r, connections)

    Bitwise.band(
      evaluate(l_connection, connections, evaluated),
      evaluate(r_connection, connections, evaluated)
    )
  end

  # @spec evaluate(or_gate(), list(connection())) :: integer()
  def evaluate({:or, l, r}, connections, evaluated) do
    l_connection = get_input_for_output(l, connections)
    r_connection = get_input_for_output(r, connections)

    Bitwise.bor(
      evaluate(l_connection, connections, evaluated),
      evaluate(r_connection, connections, evaluated)
    )
  end

  # @spec evaluate(not_gate(), list(connection())) :: integer()
  def evaluate({:not, x}, connections, evaluated) do
    x_connection = get_input_for_output(x, connections)
    Bitwise.bnot(evaluate(x_connection, connections, evaluated)) &&& (1 <<< 16) - 1
  end

  # @spec evaluate(integer_input(), list(connection())) :: integer()
  def evaluate({:integer, x}, _connections, evaluated) do
    x
  end

  def load do
    File.cwd!()
    |> Path.join("lib/2015/inputs/day_seven.txt")
    |> File.read!()
  end
end
