defmodule GameOfLifeWeb.EncodedBoard do
  alias GameOfLifeWeb.EncodedBoard
  alias GameOfLife.Board

  defstruct(
    generation: 0,
    size: [],
    aliveCells: [], # list of tuples of alive cells e.g. [[1,2], [3,4]].  Bottom left is 0,0
  )

  def encode(%Board{size: {width, height}}=b) do
    alive_cells = Enum.map(b.alive_cells, fn {x,y} -> [x,y] end)
    %EncodedBoard{ generation: b.generation, size: [width, height], aliveCells: alive_cells }
  end
end
