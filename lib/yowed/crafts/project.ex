defmodule Yowed.Crafts.Project do
  use Yowed, :schema

  alias Yowed.Accounts.User

  schema "projects" do
    field :name, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:user_id, :name])
    |> unique_constraint([:user_id, :name])
    |> assoc_constraint(:user)
  end
end
