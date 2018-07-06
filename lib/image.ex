defmodule ImgdbKholorHistogram.Image do
  alias Imagineer
  alias ImgdbKholorHistogram.ColorMaps
  alias __MODULE__

  defstruct red: ColorMaps.empty_map(), green: ColorMaps.empty_map(), blue: ColorMaps.empty_map()

  def extract_pixels(path) do
    case path |> Imagineer.load() do
      {:ok, pixel_matrix} ->
        pixels = pixel_matrix |> Map.get(:pixels) |> List.flatten()
        {:ok, pixels}

      {:error, message} ->
        {:error, message}
    end
  end

  def summarize_colors(pixels) do
    empty_image = %Image{}
    vectors = ColorMaps.convert_pixels_to_channel_vectors(pixels)

    [red, green, blue] =
      [:red, :green, :blue]
      |> Enum.map(fn channel ->
        vectors
        |> Map.get(channel)
        |> Enum.reduce(ColorMaps.empty_map(), fn value, acc ->
          Map.merge(acc, %{value => Map.get(acc, value) + 1})
        end)
      end)

    %Image{red: red, green: green, blue: blue}
  end
end
