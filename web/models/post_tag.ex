defmodule Blog.PostTag do
  use Blog.Web, :model

  schema "posts_tags" do
    belongs_to :post, Blog.Post
    belongs_to :tag, Blog.Tag

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
