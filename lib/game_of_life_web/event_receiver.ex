defmodule GameOfLifeWeb.EventReceiver do
  use GenEvent
  require Logger
  alias GameOfLifeWeb.BoardChannel

  def handle_event({:ticker_update, %GameOfLife.Ticker{}=ticker}, state) do
    Logger.info ":ticker_update: #{inspect ticker}"
    BoardChannel.broadcast_ticker_update(ticker)
    {:ok, state}
  end
end
