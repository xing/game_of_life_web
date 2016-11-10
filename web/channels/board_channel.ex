defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  alias GameOfLife.Board
  require Logger

  def join(board_channel, message, socket) do
    Logger.info "join board: message: #{inspect message},  board_channel: #{board_channel}"
    {:ok, socket}
  end

  def broadcast_board_update(%Board{origin: {x,y}} = board) do
    GameOfLifeWeb.Endpoint.broadcast! "board:#{x},#{y}", "board:update", encode(board)
  end

  def encode(%Board{size: {width, height}, origin: {x, y}}=b) do
    alive_cells = Enum.map(b.alive_cells, fn {x,y} -> [x,y] end)
    cell_attributes = Enum.reduce(b.cell_attributes, %{}, fn({key, value}, acc) -> Map.put(acc, "#{elem(key, 0)},#{elem(key, 1)}", value) end)
    %{ generation: b.generation, size: [width, height], aliveCells: alive_cells, origin: [x, y], cellAttributes: cell_attributes }
  end
end
