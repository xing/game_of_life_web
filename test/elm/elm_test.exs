defmodule GameOfLifeWeb.ElmTest do
  use ExUnit.Case, async: true

  test "Elm tests" do
    if Mix.Shell.Quiet.cmd("./test-elm.sh") != 0 do
      flunk "Elm tests failed.  Use ./test-elm.sh to run elm tests and see failures."
    end
  end
end
