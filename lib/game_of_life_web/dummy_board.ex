defmodule GameOfLifeWeb.DummyBoard do
  alias GameOfLife.Board
  alias GameOfLifeWeb.EncodedBoard


  def run(), do: run(%Board{size: {10,10}, alive_cells: [{1,1}, {5,3}]})

  def run(board) do
    GameOfLifeWeb.Endpoint.broadcast! "board:public", "board:update", EncodedBoard.encode(board)
    :timer.sleep(1000)
    run(%Board{ board | generation_number: board.generation_number + 1})
  end
end
