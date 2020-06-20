defmodule Yowed.Crafts.Message do
  use Yowed, :schema

  alias Yowed.Crafts.{Contact, Project, Template}

  @attrs [
    :subject,
    :body_html,
    :body_text,
    :status,
    :provider,
    :provider_id,
    :project_id,
    :template_id
  ]

  @required_attrs [
    :from,
    :to,
    :subject,
    :body_html,
    :body_text,
    :provider,
    :provider_id,
    :project_id,
    :template_id
  ]

  schema "messages" do
    embeds_one :from, Contact
    embeds_one :reply_to, Contact

    embeds_many :to, Contact
    embeds_many :cc, Contact
    embeds_many :bcc, Contact

    field :subject, :string

    field :body_html, :string
    field :body_text, :string

    field :status, :integer, default: 0

    field :provider, :integer
    field :provider_id, :string

    belongs_to :project, Project
    belongs_to :template, Template

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @attrs)
    |> cast_embed(:from)
    |> cast_embed(:reply_to)
    |> cast_embed(:to)
    |> cast_embed(:cc)
    |> cast_embed(:bcc)
    |> validate_required(@required_attrs)
    |> assoc_constraint(:project)
    |> assoc_constraint(:template)
  end
end
