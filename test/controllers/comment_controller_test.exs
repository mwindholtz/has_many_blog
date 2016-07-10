defmodule Blog.CommentControllerTest do
  use Blog.ConnCase

  alias Blog.Post
  alias Blog.Comment

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup do
    post_attrs  = %{body: "some content", title: "some content"}
    changeset   = Post.changeset(%Post{}, post_attrs)
    {:ok, post} = Repo.insert(changeset)
    conn = build_conn()
    conn = assign(conn, :post, post)
    {:ok, conn: conn}
  end

  test "renders form for new resources", %{conn: conn} do
    post = conn.assigns.post
    conn = get conn, post_comment_path(conn, :new, post)
    assert html_response(conn, 200) =~ "New comment"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    post = conn.assigns.post
    conn = post conn, post_comment_path(conn, :create, post), comment: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Comment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    post = conn.assigns.post
    conn = post conn, post_comment_path(conn, :create, post), comment: @invalid_attrs
    assert html_response(conn, 200) =~ "New comment"
  end

  test "deletes chosen resource", %{conn: conn} do
    post = conn.assigns.post
    comment = Repo.insert! %Comment{}
    conn = delete conn, post_comment_path(conn, :delete, post, comment)
    assert redirected_to(conn) == post_path(conn, :show, post)
    refute Repo.get(Comment, comment.id)
  end
end
