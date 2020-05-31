defmodule Yowed.Crafts.Template do
  use Yowed, :schema

  alias Yowed.Crafts.{Contact, Project, Template}

  schema "templates" do
    field :name, :string
    field :body, :string
    field :subject, :string

    embeds_one(:from, Contact, on_replace: :update)

    belongs_to(:project, Project)

    timestamps()
  end

  @doc false
  def changeset(%Template{} = template, attrs) do
    template
    |> cast(attrs, [:name, :body, :subject])
    |> validate_required([:project_id, :name])
    |> unique_constraint([:project_id, :name])
    |> assoc_constraint(:project)
    |> cast_embed(:from)
  end
end
