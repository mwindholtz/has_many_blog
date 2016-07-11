defmodule Blog.PostTagControllerTest do
  use Blog.ConnCase

  alias Blog.PostTag
  alias Blog.Post
  alias Blog.Tag

  @valid_attrs   %{}
  @invalid_attrs %{}

  setup do
    post_attrs  = %{body: "some content", title: "some content"}
    changeset   = Post.changeset(%Post{}, post_attrs)
    {:ok, post} = Repo.insert(changeset)

    tag_attrs  = %{name: "important"}
    changeset   = Tag.changeset(%Tag{}, tag_attrs)
    {:ok, tag} = Repo.insert(changeset)

    conn = build_conn()
    conn = assign(conn, :test_post, post)
    conn = assign(conn, :test_tag, tag)
    {:ok, conn: conn}
  end

  test "renders form for new resources", %{conn: conn} do
    post = conn.assigns.test_post
    conn = get conn, post_post_tag_path(conn, :new, post)
    assert html_response(conn, 200) =~ "Global Tags"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    post = conn.assigns.test_post
    tag  = conn.assigns.test_tag
    conn = post conn, post_post_tag_path(conn, :create, post), post_tag: %{tag_id: "#{tag.id}"}
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(PostTag, @valid_attrs)
  end

  # # TODO: check for valid attrs
  # # 
  # # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  # #   conn = post conn, post_tag_path(conn, :create), post_tag: @invalid_attrs
  # #   assert html_response(conn, 200) =~ "New post tag"
  # # end

  # test "deletes chosen resource", %{conn: conn} do
  #   post = conn.assigns.test_post
  #   post_tag = Repo.insert! %PostTag{}
  #   conn = delete conn, post_post_tag_path(conn, :delete, post)
  #   assert redirected_to(conn) == post_path(conn, :show, post)
  #   refute Repo.get(PostTag, post_tag.id)
  # end
end
