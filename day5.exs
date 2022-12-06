ExUnit.start()

defmodule DayTwoTest do
  use ExUnit.Case, async: true

  @test_data """
      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  describe "part 1" do
    test "following the moves in the example" do
      result =
        @test_data
        |> DayFive.parse()
        |> DayFive.move_part_1()
        |> DayFive.list_tops()

      assert result == 'CMZ'
    end
  end

  describe "parse 2" do
    test "following the moves in the example" do
      result =
        @test_data
        |> DayFive.parse()
        |> DayFive.move_part_2()
        |> DayFive.list_tops()

      assert result == 'MCD'
    end
  end
end

defmodule DayFive do
  def parse(data) do
    [state, moves] = String.split(data, "\n\n")
    {parse_state(state), parse_moves(moves)}
  end

  def move_part_1({stacks, moves}) do
    Enum.reduce(moves, stacks, &make_move_1(&2, &1))
  end

  def move_part_2({stacks, moves}) do
    Enum.reduce(moves, stacks, &make_move_2(&2, &1, []))
  end

  def list_tops(stacks), do: Enum.map(stacks, fn(stack) -> Enum.at(stack, -1) end)

  defp make_move_1(stacks, [0, _from, _to]), do: stacks
  defp make_move_1(stacks, [count, from, to]) do
    from_stack = Enum.at(stacks, from - 1)
    to_stack = Enum.at(stacks, to - 1)

    {crate, from_stack} = List.pop_at(from_stack, -1)
    to_stack = List.insert_at(to_stack, -1, crate)

    stacks =
      stacks
      |> List.replace_at(from - 1, from_stack)
      |> List.replace_at(to - 1, to_stack)

    make_move_1(stacks, [count - 1, from, to])
  end

  defp make_move_2(stacks, [0, _from, to], temp_stack) do
    to_stack = Enum.at(stacks, to - 1)
    List.replace_at(stacks, to - 1, to_stack ++ temp_stack)
  end
  defp make_move_2(stacks, [count, from, to], temp_stack) do
    from_stack = Enum.at(stacks, from - 1)

    {crate, from_stack} = List.pop_at(from_stack, -1)

    stacks = List.replace_at(stacks, from - 1, from_stack)
    temp_stack = List.insert_at(temp_stack, 0, crate)

    make_move_2(stacks, [count - 1, from, to], temp_stack)
  end

  defp parse_state(state) do
    state
    |> String.split(~r/\n.+$/)
    |> Enum.at(0)
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.reduce([], &process_row(&1, &2))
  end

  defp process_row(row, stacks), do: process_bytes(String.to_charlist(row), 0, stacks)
  defp process_bytes([], _index, stacks), do: stacks
  defp process_bytes([?\s , ?\s, ?\s | tail], index, stacks) do
    tail
    |> pop_spacer()
    |> process_bytes(index + 1, stacks)
  end

  defp process_bytes([?[, crate, ?] | tail], index, stacks) do
    tail = pop_spacer(tail)

    stack =
      stacks
      |> Enum.at(index, [])
      |> List.insert_at(-1, crate)

    stacks = case Enum.at(stacks, index) do
      nil -> List.insert_at(stacks, index, stack)
      _old_stack -> List.replace_at(stacks, index, stack)
    end

    process_bytes(tail, index + 1, stacks)
  end

  defp pop_spacer([?\s | tail]), do: tail
  defp pop_spacer(bytes), do: bytes

  defp parse_moves(moves) do
    moves
    |> String.split("\n", trim: true)
    |> Enum.map(fn(move) ->
      [_, count, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, move)
      Enum.map([count, from, to], &parse_int(&1))
    end)
  end

  defp parse_int(val), do: Integer.parse(val) |> elem(0)
end

data = File.read!("day5.data")

data
|> DayFive.parse()
|> DayFive.move_part_1()
|> DayFive.list_tops()
|> IO.inspect()

data
|> DayFive.parse()
|> DayFive.move_part_2()
|> DayFive.list_tops()
|> IO.inspect()
