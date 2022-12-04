ExUnit.start()

defmodule DayTwoTest do
  use ExUnit.Case, async: true

  @test_data """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  describe "part 1" do
    test "finding contained pairs" do
      contained =
        @test_data
        |> DayFour.parse()
        |> DayFour.count_contained()

      assert contained == 2
    end
  end

  describe "part 2" do
    test "finding overlapping pairs" do
      overlapped =
        @test_data
        |> DayFour.parse()
        |> DayFour.count_overlap()

      assert overlapped == 4
    end
  end
end

defmodule DayFour do
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn(pair) ->
      [_, lower_1, upper_1, lower_2, upper_2] = Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, pair)
      [parse_val(lower_1), parse_val(upper_1), parse_val(lower_2), parse_val(upper_2)]
    end)
  end

  defp parse_val(val), do: Integer.parse(val) |> elem(0)

  def count_contained(pairs) do
    Enum.reduce(pairs, 0, &check_contained(&1, &2))
  end

  def count_overlap(pairs) do
    Enum.reduce(pairs, 0, fn([lower_1, upper_1, lower_2, upper_2], count) ->
      case Range.disjoint?(lower_1..upper_1, lower_2..upper_2) do
        false -> count + 1
        true -> count
      end
    end)
  end

  defp check_contained([lower_1, upper_1, lower_2, upper_2], count) when lower_1 <= lower_2 and upper_1 >= upper_2, do: count + 1
  defp check_contained([lower_1, upper_1, lower_2, upper_2], count) when lower_2 <= lower_1 and upper_2 >= upper_1, do: count + 1
  defp check_contained(_paris, count), do: count
end

data = File.read!("day4.data")

data
|> DayFour.parse()
|> DayFour.count_contained()
|> IO.inspect()

data
|> DayFour.parse()
|> DayFour.count_overlap()
|> IO.inspect()
