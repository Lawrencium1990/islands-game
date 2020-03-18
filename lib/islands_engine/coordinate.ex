defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @enforce_keys [:lon, :lat]
  defstruct [:lon, :lat]

  @board_range 1..10

  def new(lon, lat) when lon in(@board_range) and lat in(@board_range), do:
    {:ok, %Coordinate{lon: lon, lat: lat}}

  def new(_, _), do: {:error, :invalid_coordinate}

end
