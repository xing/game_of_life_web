defmodule GameOfLifeWeb.DummyBoard do
  alias GameOfLife.Board
  alias GameOfLife.BoardServer
  alias GameOfLifeWeb.EncodedBoard
  alias GameOfLife.Ticker

  def run(num_rand_cells) do
     size = {95,50}
     board = %Board{size: size, alive_cells: MapSet.new(random_cells(size, 1000))}
     {:ok, pid} = BoardServer.start_link(size, board: board)
     GenEvent.notify(GameOfLife.EventManager, {:board_update, board})
     do_run(pid)
  end

  def do_run(pid) do
    {:ok, %Ticker{interval: interval}} = Ticker.get_state
    :timer.sleep(interval)
    {:ok, _ } = BoardServer.next_board_state(pid)
    {:ok, board} = BoardServer.current_board(pid)
    GenEvent.notify(GameOfLife.EventManager, {:board_update, board})
    do_run(pid)
  end

  def random_cells(size, num_rand_cells) when num_rand_cells == 0 do
    []
  end

  def random_cells(size, num_rand_cells) when num_rand_cells >= 0 do
    [random_cell(size)] ++ random_cells(size, num_rand_cells - 1)
  end

  def random_cell({width, height}) do
    {Enum.random(0..width - 1), Enum.random(0..height - 1)}
  end
end
