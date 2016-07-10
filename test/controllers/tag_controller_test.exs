defmodule Blog.TagControllerTest do
  use Blog.ConnCase

  alias Blog.Tag
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tag_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tags"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, tag_path(conn, :new)
    assert html_response(conn, 200) =~ "New tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, tag_path(conn, :create), tag: @valid_attrs
    assert redirected_to(conn) == tag_path(conn, :index)
    assert Repo.get_by(Tag, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tag_path(conn, :create), tag: @invalid_attrs
    assert html_response(conn, 200) =~ "New tag"
  end

  test "deletes chosen resource", %{conn: conn} do
    tag = Repo.insert! %Tag{}
    conn = delete conn, tag_path(conn, :delete, tag)
    assert redirected_to(conn) == tag_path(conn, :index)
    refute Repo.get(Tag, tag.id)
  end
end
