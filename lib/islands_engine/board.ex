defmodule IslandsEngine.Board do

  alias IslandsEngine.{Coordinate, Island}

  def new, do: %{}

  def all_islands_positioned?(board), do:
    Enum.all?(Island.list_types(), &(Map.has_key?(board, &1)))

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn{key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)
  end

end
