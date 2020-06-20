defmodule Yowed.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :from, :map, null: false
      add :reply_to, :map

      add :to, {:array, :map}, null: false
      add :cc, {:array, :map}
      add :bcc, {:array, :map}

      add :subject, :string

      add :body_html, :text, null: false
      add :body_text, :text, null: false

      add :status, :integer, null: false

      add :provider, :integer, null: false
      add :provider_id, :string

      ref_projects = references(:projects, type: :binary_id, on_delete: :delete_all)
      add :project_id, ref_projects, null: false

      ref_templates = references(:templates, type: :binary_id, on_delete: :nilify_all)
      add :template_id, ref_templates

      timestamps()
    end

    create index(:messages, [:status])

    create index(:messages, [:provider])
    create index(:messages, [:provider_id])

    create index(:messages, [:project_id])
    create index(:messages, [:template_id])

    create unique_index(:messages, [:provider, :project_id])
  end
end
