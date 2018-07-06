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

  describe "ImgdbKholorHistogram.ColorMaps.convert_pixels_to_channel_vectors/1" do
    test "empty pixel list" do
      ColorMaps.convert_pixels_to_channel_vectors([])
      |> Kernel.==(%{:red => [], :green => [], :blue => []})
      |> assert()
    end

    test "single pixel list" do
      ColorMaps.convert_pixels_to_channel_vectors([{0, 3, 2}])
      |> Kernel.==(%{:red => [0], :green => [3], :blue => [2]})
      |> assert()
    end

    test "list of pixels" do
      input_pixel_list = [
        {0, 3, 2},
        {0, 3, 2},
        {100, 20, 10}
      ]

      expected_channel_vector = %{
        :red => [0, 0, 100],
        :green => [3, 3, 20],
        :blue => [2, 2, 10]
      }

      ColorMaps.convert_pixels_to_channel_vectors(input_pixel_list)
      |> Kernel.==(expected_channel_vector)
      |> assert()
    end
  end
end
