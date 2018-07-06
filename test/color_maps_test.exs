defmodule ColorMapsTest do
  use ExUnit.Case
  alias ImgdbKholorHistogram.ColorMaps, as: ColorMaps

  describe "ImgdbKholorHistogram.ColorMaps.empty_map/0" do
    test "length" do
      empty_map = ColorMaps.empty_map()

      assert Enum.count(empty_map) === 256, "8bit color = 256 possible values"
    end

    test "only zeroes" do
      empty_map = ColorMaps.empty_map()

      empty_map
      |> Enum.each(fn {value, count} ->
        assert count == 0, "expected 0 for #{value}, got #{count}"
      end)
    end

    test "0..255" do
      empty_map = ColorMaps.empty_map()
      expected_keys = 0..255 |> Enum.to_list()
      actual_keys = empty_map |> Map.keys() |> Enum.sort()

      assert actual_keys == expected_keys, "list should contains only between 0 and 255 only once"
    end
  end
end
