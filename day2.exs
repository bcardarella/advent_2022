ExUnit.start()

defmodule DayTwoTest do
  use ExUnit.Case, async: true

  @test_data """
  A Y
  B X
  C Z
  """

  describe "part 1" do
    test "sample data should score as 15" do
      assert DayTwo.parse(@test_data) |> DayTwo.score() == 15
    end
  end

  describe "part 2" do
    test "" do
      assert DayTwo.parse(@test_data) |> DayTwo.score2() ==12
    end
  end
end

defmodule DayTwo do
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end

  def score(rounds) do
    Enum.reduce(rounds, 0, fn([opp, you], total) ->
      opp = convert1(opp)
      you = convert1(you)

      shape_score(you) + win_score({opp, you}) + total
    end)
  end

  def score2(rounds) do
    Enum.reduce(rounds, 0, fn([opp, outcome], total) ->
      opp = convert1(opp)
      you = convert2(opp, outcome)

      shape_score(you) + win_score({opp, you}) + total
    end)
  end

  defp shape_score(:rock), do: 1
  defp shape_score(:paper), do: 2
  defp shape_score(:scissors), do: 3

  defp win_score({hand, hand}), do: 3
  defp win_score(round) when round in [{:rock, :scissors}, {:paper, :rock}, {:scissors, :paper}], do: 0
  defp win_score(round) when round in [{:rock, :paper}, {:paper, :scissors}, {:scissors, :rock}], do: 6

  defp convert1(hand) when hand in ~w{A X}, do: :rock
  defp convert1(hand) when hand in ~w{B Y}, do: :paper
  defp convert1(hand) when hand in ~w{C Z}, do: :scissors

  defp convert2(hand, "Y"), do: hand
  defp convert2(:rock, "X"), do: :scissors
  defp convert2(:rock, "Z"), do: :paper
  defp convert2(:paper, "X"), do: :rock
  defp convert2(:paper, "Z"), do: :scissors
  defp convert2(:scissors, "X"), do: :paper
  defp convert2(:scissors, "Z"), do: :rock
end

data = File.read!("day2.data")

data
|> DayTwo.parse()
|> DayTwo.score()
|> IO.inspect(label: "Part 1")


data
|> DayTwo.parse()
|> DayTwo.score2()
|> IO.inspect(label: "Part 2")
