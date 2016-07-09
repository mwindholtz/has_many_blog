defmodule Blog.PageControllerTest do
  use Blog.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "My Demo Blog"
  end
end
