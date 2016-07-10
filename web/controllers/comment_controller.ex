defmodule Blog.CommentController do
  use Blog.Web, :controller

  plug :find_post
  alias Blog.Comment

  plug :scrub_params, "comment" when action in [:create, :update]

  def new(conn, _params) do
    changeset = Comment.changeset(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    post = conn.assigns.post
    changeset = 
      post
        |> Ecto.Model.build(:comments)
        |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = conn.assigns.post

    # TODO: need to scope for current post
    comment = Repo.get!(Comment, id)  

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: post_path(conn, :show, post))
  end

  defp find_post(conn, _opts) do
    assign(conn, :post,
           Repo.get!(Blog.Post, conn.params["post_id"]))
  end

end

