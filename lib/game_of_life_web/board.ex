defmodule GameOfLife.Board do
  defstruct(
    generation_number: 0,
    size: {10,10}, # size of board {x,y}
    alive_cells: [], # list of tuples of alive cells e.g. [{1,1}, {5,2}].  Bottom left is 0,0
  )
end
