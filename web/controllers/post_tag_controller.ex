defmodule Blog.PostTagController do
  use Blog.Web, :controller

  alias Blog.PostTag

  plug :scrub_params, "post_tag" when action in [:create, :update]

  def new(conn, _params) do
    changeset = PostTag.changeset(%PostTag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_tag" => post_tag_params}) do
    changeset = PostTag.changeset(%PostTag{}, post_tag_params)

    case Repo.insert(changeset) do
      {:ok, _post_tag} ->
        conn
        |> put_flash(:info, "Post tag created successfully.")
        |> redirect(to: post_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_tag = Repo.get!(PostTag, id)
    render(conn, "show.html", post_tag: post_tag)
  end

  def delete(conn, %{"id" => id}) do
    post_tag = Repo.get!(PostTag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_tag)

    conn
    |> put_flash(:info, "Post tag deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
