defmodule GameOfLifeWeb.PageControllerTest do
  use GameOfLifeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello GameOfLifeWeb!"
  end
end
