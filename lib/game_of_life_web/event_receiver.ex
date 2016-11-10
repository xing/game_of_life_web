defmodule GameOfLifeWeb.EventReceiver do
  use GenEvent
  require Logger
  alias GameOfLifeWeb.{BoardChannel, GridChannel}

  def handle_event({:ticker_update, %GameOfLife.Ticker{}=ticker}, state) do
    GridChannel.broadcast_ticker_update(ticker)
    {:ok, state}
  end

  def handle_event({:board_update, board}, state) do
    BoardChannel.broadcast_board_update(board)
    {:ok, state}
  end
end
