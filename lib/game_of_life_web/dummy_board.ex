defmodule GameOfLifeWeb.DummyBoard do

  def run(), do: run(1)
  
  def run(generation_number) do
    GameOfLifeWeb.Endpoint.broadcast! "board:public", "board:update", %{id: 1, generationNumber: generation_number}
    :timer.sleep(1000)
    run(generation_number + 1)
  end
end
