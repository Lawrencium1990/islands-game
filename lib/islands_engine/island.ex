defmodule IslandsEngine.Island do
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(type, %Coordinate{} = upper_left) do
    #%Island{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}
    with [_|_] = offsets <- offsets(type),
      %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
      do
        {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
      else
        error -> error
      end
  end

  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true -> hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}
      false -> :miss
    end
  end

  def forested?(island), do:
    MapSet.equal?(island.coordinates, island.hit_coordinates)

  def list_types, do:
    [:atoll, :dot, :l_shape, :s_shape, :square]

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island(board, key, island) do
        true -> {:error, :overlapping_island}
        false -> Map.put(board, key, island)
    end
  end

  defp overlaps_existing_island(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  defp offsets(:square), do:
    [{0,0},{0,1},{1,0},{1,1}]

  defp offsets(:atoll), do:
    [{0,0},{0,1},{1,1},{2,0},{2,1}]

  defp offsets(:dot), do:
    [{0,0}]

  defp offsets(:l_shape), do:
    [{0,0},{1,0},{2,0},{2,1}]

  defp offsets(:s_shape), do:
    [{0,1},{0,2},{1,0},{1,1}]

  defp offsets(_), do:
    {:error, :invalid_island_type}

  defp add_coordinates(offset, upper_left) do
    offset
    |> Enum.reduce_while(MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{lon: lon, lat: lat},
    {lon_offset, lat_offset}) do
      case Coordinate.new(lon + lon_offset, lat + lat_offset) do
        {:ok, coordinate} -> {:cont, MapSet.put(coordinates, coordinate)}
        {:error, _} -> {:halt, {:error, :not_in_range}}
      end
  end

end
