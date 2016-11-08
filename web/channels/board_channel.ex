defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  require Logger

  def join("board:public", message, socket) do
    Logger.info "join board: #{inspect message}"
    {:ok, %{started: true, interval: 10}, socket}
  end

  def handle_in("ticker:stop", _, socket) do
   Logger.info "handle_in ticker:stop"
   {:reply, :ok, socket}
 end

 def handle_in("ticker:start", _, socket) do
   Logger.info "handle_in ticker:start"
   {:reply, :ok, socket}
 end

end
