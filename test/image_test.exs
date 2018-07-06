defmodule ImageTest do
  use ExUnit.Case
  alias ImgdbKholorHistogram.Image, as: Image

  describe "ImgdbKholorHistogram.Image.extract_pixels/1" do
    test "valid image file" do
      case "./test/pics/dummy.png" |> Image.extract_pixels() do
        {:ok, pixels} -> assert is_list(pixels), "extract_pixels/1 should return list of pixels"
        {:error, message} -> assert false, message
      end
    end

    test "invalid(not PNG) image file" do
      case "./test/pics/not-a-png.jpg" |> Image.extract_pixels() do
        {:ok, pixels} -> assert false, "extract_pixels/1 can take only PNG files"
        {:error, message} -> assert true
      end
    end

    test "not existing file" do
      case "./test/pics/404.png" |> Image.extract_pixels() do
        {:ok, pixels} -> assert false, "extract_pixels/1 should return error on non-existing file"
        {:error, message} -> assert true
      end
    end
  end
end
