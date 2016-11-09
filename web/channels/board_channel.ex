defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  alias GameOfLife.Ticker
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

  @doc "Encodes the object as required for the browser"
  def encode(%Ticker{ticker_state: ticker_state, interval: interval}) do
    %{started: ticker_state == :started, interval: interval}
  end
end
