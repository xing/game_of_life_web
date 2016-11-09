defmodule GameOfLifeWeb.DummyBoard do
  alias GameOfLife.Board
  alias GameOfLifeWeb.EncodedBoard


  def run(num_rand_cells), do: run(%Board{size: {95,50}, alive_cells: [{1,1}, {5,3}]}, num_rand_cells)

  def run(board, num_rand_cells) do
    GameOfLifeWeb.Endpoint.broadcast! "board:public", "board:update", EncodedBoard.encode(board)
    :timer.sleep(500)
    run(%Board{ board | generation: board.generation + 1,
      alive_cells: random_cells(board.size, num_rand_cells)}, num_rand_cells)
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
