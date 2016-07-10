defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :body, :string
    belongs_to :post, Blog.Post

    timestamps
  end

  @required_fields ~w(body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{} ) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
