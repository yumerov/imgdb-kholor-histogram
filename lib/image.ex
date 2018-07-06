defmodule ImgdbKholorHistogram.Image do
  def empty_map do
    0..255
    |> Enum.map(&{&1, 0})
    |> Map.new()
  end
end
