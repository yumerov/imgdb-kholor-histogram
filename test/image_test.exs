defmodule ImageTest do
  use ExUnit.Case
  alias ImgdbKholorHistogram.Image
  alias ImgdbKholorHistogram.ColorMaps

  describe "ImgdbKholorHistogram.Image.extract_pixels/1" do
    test "valid image file" do
      case "./test/pics/dummy.png" |> Image.extract_pixels() do
        {:ok, pixels} -> assert is_list(pixels), "extract_pixels/1 should return list of pixels"
        {:error, message} -> assert false, message
      end
    end

    test "invalid(not PNG) image file" do
      case "./test/pics/not-a-png.jpg" |> Image.extract_pixels() do
        {:ok, _} -> assert false, "extract_pixels/1 can take only PNG files"
        {:error, _} -> assert true
      end
    end

    test "not existing file" do
      case "./test/pics/404.png" |> Image.extract_pixels() do
        {:ok, _} -> assert false, "extract_pixels/1 should return error on non-existing file"
        {:error, _} -> assert true
      end
    end
  end

  describe "%ImgdbKholorHistogram.Image{}" do
    test "three channel color map" do
      empty_three_channel_map = %Image{}
      empty_map = ColorMaps.empty_map()
      channels = [:red, :green, :blue]

      Enum.each(channels, fn channel ->
        message = "#{Atom.to_string(channel)} channel should be an empty color map"
        is_empty_map = Map.get(empty_three_channel_map, channel) == empty_map
        assert is_empty_map, message
      end)
    end
  end

  describe "ImgdbKholorHistogram.Image.summarize_colors/1" do
    test "empty pixel list" do
      actual = Image.summarize_colors([])
      expected = %Image{}

      assert actual == expected
    end

    test "single pixel list" do
      actual = Image.summarize_colors([{0, 0, 0}])

      expected = %Image{
        :red => %Image{} |> Map.get(:red) |> Map.merge(%{0 => 1}),
        :green => %Image{} |> Map.get(:green) |> Map.merge(%{0 => 1}),
        :blue => %Image{} |> Map.get(:blue) |> Map.merge(%{0 => 1})
      }

      assert actual == expected
    end

    test "pixel list" do
      actual =
        Image.summarize_colors([
          {0, 0, 0},
          {0, 0, 1},
          {0, 1, 2},
          {1, 2, 3},
          {2, 1, 0},
          {67, 1, 99}
        ])

      expected = %Image{
        :red => %Image{} |> Map.get(:red) |> Map.merge(%{0 => 3, 1 => 1, 2 => 1, 67 => 1}),
        :green => %Image{} |> Map.get(:green) |> Map.merge(%{0 => 2, 1 => 3, 2 => 1}),
        :blue =>
          %Image{} |> Map.get(:blue) |> Map.merge(%{0 => 2, 1 => 1, 2 => 1, 3 => 1, 99 => 1})
      }

      assert actual == expected
    end
  end
end
