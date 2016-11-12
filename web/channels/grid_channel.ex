defmodule GameOfLifeWeb.GridChannel do
  use Phoenix.Channel
  alias GameOfLife.{Ticker, Grid, GridManager}
  require Logger

  def join("grid", message, socket) do
    Logger.info "join grid: #{inspect message}"
    {:ok, ticker} = Ticker.get_state
    {:ok, %Grid{boards: boards}} = GridManager.get_state
    {:ok, %{ticker: encode(ticker), boards: encode(boards)}, socket}
  end

  def handle_in("ticker:stop", _, socket) do
   GameOfLife.Ticker.stop_ticker
   {:reply, :ok, socket}
 end

 def handle_in("ticker:start", _, socket) do
   GameOfLife.Ticker.start_ticker
   {:reply, :ok, socket}
 end

  def handle_in("ticker:interval_update", %{"newInterval" => new_interval}, socket) do
    GameOfLife.Ticker.set_interval(new_interval)
    {:reply, :ok, socket}
  end

  def broadcast_ticker_update(ticker) do
    GameOfLifeWeb.Endpoint.broadcast! "grid", "ticker:update", encode(ticker)
  end

  @doc "Encodes the object as required for the browser"
  def encode(%Ticker{ticker_state: ticker_state, interval: interval}) do
    %{started: ticker_state == :started, interval: interval}
  end

  def encode([]), do: []
  def encode([{_x, _y} | _t]=points) do
    Enum.map(points, fn {x,y} -> [x,y] end)
  end
end
