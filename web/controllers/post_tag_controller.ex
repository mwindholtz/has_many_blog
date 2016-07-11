defmodule Blog.PostTagController do
  use Blog.Web, :controller

  alias Blog.PostTag

  plug :find_post
  plug :scrub_params, "post_tag" when action in [:create, :update]

  def new(conn, _params) do
    changeset = PostTag.changeset(%PostTag{})
    tags = Repo.all(Blog.Tag)
    render(conn, "new.html", changeset: changeset, tags: tags)  
  end

  def create(conn, %{"post_tag" => post_tag_params}) do    
    %{"tag_id" => tag_id} = post_tag_params
     post = conn.assigns.post
    
    case Repo.insert(%PostTag{post_id: post.id, tag_id: int(tag_id)}) do
      {:ok, _post_tag} ->
        conn
        |> put_flash(:info, "Tag added successfully.")
        |> redirect(to: post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   post = conn.assigns.post
  #   post_tag = Repo.get!(PostTag, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(post_tag)

  #   conn
  #   |> put_flash(:info, "Tag removed successfully.")
  #   |> redirect(to: post_path(conn, :index))
  # end

  defp find_post(conn, _opts) do
    assign(conn, :post,
           Repo.get!(Blog.Post, conn.params["post_id"]))
  end

  defp get_tag(post_tag_params) do
    %{"tag_id" => tag_id} = post_tag_params
    Repo.get!(Blog.Tag, tag_id)
  end
  
  defp int(string) do
    String.to_integer(string)
  end
end
