defmodule ImgdbKholorHistogram.Image do
  alias Imagineer

  def extract_pixels(path) do
    case path |> Imagineer.load() do
      {:ok, pixel_matrix} ->
        pixels = pixel_matrix |> Map.get(:pixels) |> List.flatten()
        {:ok, pixels}

      {:error, message} ->
        {:error, message}
    end
  end
end
