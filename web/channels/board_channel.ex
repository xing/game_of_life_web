defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  require Logger

  def join("board:public", message, socket) do
    Logger.info "join board: #{inspect message}"
    {:ok, %{started: true, interval: 10}, socket}
  end
  def join("board:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
