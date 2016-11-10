defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  alias GameOfLife.Ticker
  alias GameOfLife.Board
  require Logger

  def join("board:public", message, socket) do
    Logger.info "join board: #{inspect message}"
    {:ok, ticker} = Ticker.get_state
    {:ok, encode(ticker), socket}
  end

  def handle_in("ticker:stop", _, socket) do
   Logger.info "handle_in ticker:stop"
   GameOfLife.Ticker.stop_ticker
   {:reply, :ok, socket}
 end

 def handle_in("ticker:start", _, socket) do
   Logger.info "handle_in ticker:start"
   GameOfLife.Ticker.start_ticker
   {:reply, :ok, socket}
 end

  def handle_in("ticker:interval_update", %{"newInterval" => new_interval}, socket) do
    Logger.info "handle_in ticker:interval_update new_interval: #{inspect new_interval}"
    GameOfLife.Ticker.set_interval(new_interval)
    {:reply, :ok, socket}
  end

  def broadcast_ticker_update(ticker) do
    GameOfLifeWeb.Endpoint.broadcast! "board:public", "ticker:update", encode(ticker)
  end

  def broadcast_board_update(board) do
    GameOfLifeWeb.Endpoint.broadcast! "board:public", "board:update", encode(board)
  end

  @doc "Encodes the object as required for the browser"
  def encode(%Ticker{ticker_state: ticker_state, interval: interval}) do
    %{started: ticker_state == :started, interval: interval}
  end

  def encode(%Board{size: {width, height}}=b) do
    alive_cells = Enum.map(b.alive_cells, fn {x,y} -> [x,y] end)
    %{ generation: b.generation, size: [width, height], aliveCells: alive_cells }
  end
end
