defmodule Yowed.Crafts.Template do
  use Yowed, :schema

  alias Yowed.Crafts.{Contact, Project, Template}
  alias Yowed.Embed

  schema "templates" do
    field :name, :string
    field :subject, :string

    field :body, :string
    field :body_preview, :string

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
    |> cast_body_preview()
  end

  defp cast_body_preview(changeset) do
    body = get_change(changeset, :body)

    if body && String.trim(body) != "" do
      case Embed.call("template", [body]) do
        {:ok, body_preview} ->
          put_change(changeset, :body_preview, body_preview)

        {:error, _reason} ->
          changeset
          |> add_error(:body, "Failed to parse MJML")
          |> put_change(:body_preview, "")
      end
    else
      changeset
    end
  end
end
