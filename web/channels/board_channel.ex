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
    %{ generation: b.generation, size: [width, height], aliveCells: alive_cells, origin: [x, y] }
  end
end
