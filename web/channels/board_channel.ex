defmodule GameOfLifeWeb.BoardChannel do
  use Phoenix.Channel
  require Logger

  def join("board:public", message, socket) do
    Logger.info "join: #{inspect message}"
    {:ok, socket}
  end
  def join("board:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
