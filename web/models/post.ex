defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    has_many :comments, Blog.Comment
    many_to_many :tags, Blog.Tag, join_through: Blog.PostTag, on_replace: :delete
    field :title, :string
    field :body, :string
    timestamps
  end

  @required_fields ~w(title body)
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
