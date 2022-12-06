ExUnit.start()

defmodule DayTwoTest do
  use ExUnit.Case, async: true

  describe "Part 1" do
    test "first example" do
      assert DaySix.marker_start("bvwbjplbgvbhsrlpgdmjqwftvncz", :start) == 5
    end
    test "second example" do
      assert DaySix.marker_start("nppdvjthqldpwncqszvftbrmjlhg", :start) == 6
    end
    test "third example" do
      assert DaySix.marker_start("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", :start) == 10
    end
    test "fourth example" do
      assert DaySix.marker_start("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", :start) == 11
    end
  end

  describe "Part 2" do
    test "first example" do
      assert DaySix.marker_start("mjqjpqmgbljsphdztnvjfqwrcgsmlb", :message) == 19
    end
    test "second example" do
      assert DaySix.marker_start("bvwbjplbgvbhsrlpgdmjqwftvncz", :message) == 23
    end
    test "third example" do
      assert DaySix.marker_start("nppdvjthqldpwncqszvftbrmjlhg", :message) == 23
    end
    test "fourth example" do
      assert DaySix.marker_start("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", :message) == 29
    end
    test "fifth example" do
      assert DaySix.marker_start("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", :message) == 26
    end
  end
end

defmodule DaySix do
  def marker_start(signal, type) do
    seg_length = case type do
      :start -> 4
      :message -> 14
    end

    index =
      signal
      |> String.to_charlist()
      |> find_marker_start(seg_length, 0)

    index + seg_length
  end

  defp find_marker_start(signal, seg_length, char_num) do
    Enum.take(signal, seg_length)
    |> chars_uniq?()
    |> case do
      true -> char_num
      false -> find_marker_start(List.delete_at(signal, 0), seg_length, char_num + 1)
    end
  end

  defp chars_uniq?(chars) do
    Enum.uniq(chars)
    |> length()
    |> :erlang.==(length(chars))
  end
end

data = File.read!("day6.data")

DaySix.marker_start(data, :start) |> IO.inspect()
DaySix.marker_start(data, :message) |> IO.inspect()
