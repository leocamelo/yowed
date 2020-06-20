defmodule Yowed.Crafts.Template do
  use Yowed, :schema

  alias Yowed.Crafts.{Contact, Message, Project}
  alias Yowed.Embed

  schema "templates" do
    field :name, :string
    field :subject, :string

    field :body, :string
    field :body_preview, :string

    embeds_one :from, Contact, on_replace: :update

    belongs_to :project, Project

    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = template, attrs) do
    template
    |> cast(attrs, [:name, :body, :subject])
    |> validate_required([:project_id, :name])
    |> unique_constraint([:project_id, :name])
    |> assoc_constraint(:project)
    |> cast_embed(:from)
    |> cast_body_preview()
  end

  defp cast_body_preview(changeset) do
    case get_change(changeset, :body, :nochange) do
      :nochange ->
        changeset

      nil ->
        put_change(changeset, :body_preview, nil)

      body ->
        if String.trim(body) != "" do
          do_cast_body_preview(changeset, body)
        else
          put_change(changeset, :body_preview, nil)
        end
    end
  end

  defp do_cast_body_preview(changeset, body) do
    case Embed.call("template", [body]) do
      {:ok, body_preview} ->
        put_change(changeset, :body_preview, body_preview)

      {:error, _reason} ->
        changeset
        |> put_change(:body_preview, "")
        |> add_error(:body, "Failed to parse MJML")
    end
  end
end
