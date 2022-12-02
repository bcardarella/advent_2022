ExUnit.start()

defmodule DayOneTest do
  use ExUnit.Case, async: true

  @test_data """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  describe "Part 1" do
    test "the first elf carries 6_000 calories" do
      results = DayOne.parse(@test_data)

      assert Enum.at(results, 0) == 6_000
    end

    test "the second elf carries 4_000 calores" do
      results = DayOne.parse(@test_data)

      assert Enum.at(results, 1) == 4_000
    end

    test "the third elf carries 11_000 calories" do
      results = DayOne.parse(@test_data)

      assert Enum.at(results, 2) == 11_000
    end

    test "the fourth elf carries 24_000 calories" do
      results = DayOne.parse(@test_data)

      assert Enum.at(results, 3) == 24_000
    end

    test "the fifth elf carries 10_000 calories" do
      results = DayOne.parse(@test_data)

      assert Enum.at(results, 4) == 10_000
    end

    test "fourth elf carries most calories" do
      assert DayOne.most(@test_data) == {24_000, 4}
    end
  end
end

defmodule DayOne do
  def parse(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn(values) ->
      values
      |> String.split("\n", trim: true)
      |> Enum.reduce(0, fn(value, acc) -> elem(Integer.parse(value), 0) + acc end)
    end)
  end

  def most(data) do
    data
    |> prepare()
    |> Enum.max_by(&elem(&1, 0))
  end

  def top_three(data) do
    data
    |> prepare()
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.take(3)
    |> Enum.reduce(0, fn({sum, _}, acc) -> sum + acc end)
  end

  defp prepare(data) do
    data
    |> parse()
    |> Enum.with_index(fn(sum, index) -> {sum, index + 1} end)
  end
end

data = File.read!("day1.data")

data
|> DayOne.most()
|> IO.inspect(label: "Part 1")

data
|> DayOne.top_three()
|> IO.inspect(label: "Part 2")
