ExUnit.start()

defmodule DayTwoTest do
  use ExUnit.Case, async: true

  @test_data """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  describe "part 1" do
    test "finding the rucksack's shared items" do
      shared_items =
        DayThree.parse(@test_data)
        |> DayThree.shared_items()

      assert Enum.at(shared_items, 0) == "p"
      assert Enum.at(shared_items, 1) == "L"
      assert Enum.at(shared_items, 2) == "P"
      assert Enum.at(shared_items, 3) == "v"
      assert Enum.at(shared_items, 4) == "t"
      assert Enum.at(shared_items, 5) == "s"
    end

    test "the shared items priority sum is 157" do
      shared_items =
        DayThree.parse(@test_data)
        |> DayThree.shared_items()

      assert DayThree.priority_sum(shared_items) == 157
    end
  end

  describe "part 2" do
    test "grouped sum" do
      shared_items =
        DayThree.group_parse(@test_data)
        |> DayThree.shared_items()

      assert DayThree.priority_sum(shared_items) == 70
    end
  end
end

defmodule DayThree do
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn(rucksack) ->
      String.split_at(rucksack, (String.length(rucksack) / 2) |> Kernel.trunc())
      |> Tuple.to_list()
    end)
  end

  def group_parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
  end

  def shared_items(rucksacks) do
    rucksacks
    |> Enum.reduce([], &intersect_containers(&1, &2))
    |> Enum.reverse()
  end

  defp intersect_containers([], shared), do: shared
  defp intersect_containers([c1, c2 | []], shared) do
    [do_container_intersect(c1, c2) | shared]
  end
  defp intersect_containers([c1, c2 | containers], shared) do
    intersect_containers([do_container_intersect(c1, c2) | containers], shared)
  end

  defp do_container_intersect(c1, c2) do
    m1 = String.to_charlist(c1) |> MapSet.new()
    m2 = String.to_charlist(c2) |> MapSet.new()
    MapSet.intersection(m1, m2) |> MapSet.to_list() |> List.to_string()
  end

  def priority_sum(shared_items) do
    shared_items
    |> Enum.reduce(0, fn(item, sum) ->
      sum + priority_value(item)
    end)
  end

  defp priority_value(item) when is_binary(item), do: priority_value(String.to_charlist(item))
  defp priority_value([item]) when item in ?a..?z, do: (item - ?a) + 1
  defp priority_value([item]) when item in ?A..?Z, do: (item - ?A) + 27
end

data = File.read!("day3.data")

data
|> DayThree.parse()
|> DayThree.shared_items()
|> DayThree.priority_sum()
|> IO.inspect()

data
|> DayThree.group_parse()
|> DayThree.shared_items()
|> DayThree.priority_sum()
|> IO.inspect()
