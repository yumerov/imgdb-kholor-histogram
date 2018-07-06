defmodule ImgdbKholorHistogram.ColorMaps do
  def empty_map do
    0..255
    |> Enum.map(&{&1, 0})
    |> Map.new()
  end

  defp convert_pixels_to_channel_vectors_reduce({red, green, blue}, %{
         :red => acc_red,
         :green => acc_green,
         :blue => acc_blue
       }) do
    %{
      :red => acc_red ++ [red],
      :green => acc_green ++ [green],
      :blue => acc_blue ++ [blue]
    }
  end

  def convert_pixels_to_channel_vectors([]) do
    %{
      :red => [],
      :green => [],
      :blue => []
    }
  end

  def convert_pixels_to_channel_vectors(pixels) do
    init_map = convert_pixels_to_channel_vectors([])

    pixels
    |> Enum.reduce(init_map, &convert_pixels_to_channel_vectors_reduce/2)
  end
end
