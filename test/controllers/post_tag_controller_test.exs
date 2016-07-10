defmodule Blog.PostTagControllerTest do
  use Blog.ConnCase

  alias Blog.PostTag

  @valid_attrs %{}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_tag_path(conn, :new)
    assert html_response(conn, 200) =~ "New post tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_tag_path(conn, :create), post_tag: @valid_attrs
# TODO:     assert redirected_to(conn) == post_tag_path(conn, :index)
    assert Repo.get_by(PostTag, @valid_attrs)
  end

  # TODO: check for valid attrs
  # 
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, post_tag_path(conn, :create), post_tag: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New post tag"
  # end

  test "deletes chosen resource", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = delete conn, post_tag_path(conn, :delete, post_tag)
# TODO: assert redirected_to(conn) == post_tag_path(conn, :index)
    refute Repo.get(PostTag, post_tag.id)
  end
end
