defmodule Blog.PostTagController do
  use Blog.Web, :controller

  alias Blog.PostTag

  plug :find_post
  plug :scrub_params, "post_tag" when action in [:create, :update]

  def new(conn, _params) do
    tags = Repo.all(Blog.Tag)
    render(conn, "new.html", tags: tags)
  end

  # def create(conn, %{"post_tag" => post_tag_params}) do
  #   post = conn.assigns.post
  #   changeset = 
  #     post
  #       |> Ecto.build_assoc(:post_tag)
  #       |> PostTag.changeset(post_tag_params)

  #   case Repo.insert(changeset) do
  #     {:ok, _post_tag} ->
  #       conn
  #       |> put_flash(:info, "Post tag created successfully.")
  #       |> redirect(to: post_path(conn, :index))

  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   post = conn.assigns.post
  #   post_tag = Repo.get!(PostTag, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(post_tag)

  #   conn
  #   |> put_flash(:info, "Post tag deleted successfully.")
  #   |> redirect(to: post_path(conn, :index))
  # end

  defp find_post(conn, _opts) do
    assign(conn, :post,
           Repo.get!(Blog.Post, conn.params["post_id"]))
  end

end
