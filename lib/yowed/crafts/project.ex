defmodule Yowed.Crafts.Project do
  use Yowed, :schema

  alias Yowed.Accounts.User
  alias Yowed.Crafts.{Message, Template}

  schema "projects" do
    field :name, :string

    belongs_to :user, User

    has_many :templates, Template
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:user_id, :name])
    |> unique_constraint([:user_id, :name])
    |> assoc_constraint(:user)
  end
end
