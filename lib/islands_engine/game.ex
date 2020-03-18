defmodule IslandsEngine.Game do
  use GenServer

  def handle_info(:first, state) do
    IO.puts "I Bims vong Text her"
    {:noreply, state}
  end

  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end

  def demo_call(game) do
    GenServer.call(game, :demo_call)
  end
end
