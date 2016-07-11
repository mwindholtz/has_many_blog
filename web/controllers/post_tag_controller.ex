defmodule Blog.PostTagController do
  use Blog.Web, :controller

  alias Blog.Tag

  plug :find_post
  plug :scrub_params, "post_tag" when action in [:create, :update]

  def new(conn, _params) do
    changeset = Blog.PostTag.changeset(%Blog.PostTag{})
    tags = Repo.all(Blog.Tag)
    render(conn, "new.html", changeset: changeset, tags: tags)  
  end

  def create(conn, %{"post_tag" => post_tag_params}) do    
    tag  = get_tag(post_tag_params)
    post = conn.assigns.post  |> Repo.preload(:tags)
    tags = post.tags ++ [tag]    

    tag_changesets = Enum.map(tags, &Ecto.Changeset.change/1)
    changeset = Ecto.Changeset.change(post)
      |> Ecto.Changeset.put_assoc(:tags, tag_changesets)

    case Repo.update(changeset) do
      {:ok, _post_tag} ->
        conn
        |> put_flash(:info, "Tag added successfully.")
        |> redirect(to: post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = conn.assigns.post  |> Repo.preload(:tags)
    tag = Repo.get!(Tag, id)
    tags = post.tags -- [tag]

    tag_changesets = Enum.map(tags, &Ecto.Changeset.change/1)
    changeset = Ecto.Changeset.change(post)
      |> Ecto.Changeset.put_assoc(:tags, tag_changesets)

    case Repo.update(changeset) do
      {:ok, _post_tag} ->
        conn
          |> put_flash(:info, "Tag removed successfully.")
          |> redirect(to: post_path(conn, :show, post))

      {:error, _changeset} ->
        conn
          |> put_flash(:info, "Error: Tag not removed.")
          |> redirect(to: post_path(conn, :show, post))
    end


    # TODO: Using PostTag seems wrong when we have a many_to_many, need a better way
#    [post_tag] = Repo.all(from pt in PostTag, where: (pt.post_id = ^post_id) and (pt.tag_id = ^id))
    
#     Repo.delete!(post_tag)
  end

  defp find_post(conn, _opts) do
    assign(conn, :post,
           Repo.get!(Blog.Post, conn.params["post_id"]))
  end

  defp get_tag(post_tag_params) do
    %{"tag_id" => tag_id} = post_tag_params
    Repo.get!(Blog.Tag, tag_id)
  end
  
  # defp int(string) do
  #   String.to_integer(string)
  # end
end
