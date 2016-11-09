defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  require Logger

  def join("board:public", message, socket) do
    Logger.info "join board: #{inspect message}"
    {:ok, %{started: true, interval: 10}, socket}
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
end
