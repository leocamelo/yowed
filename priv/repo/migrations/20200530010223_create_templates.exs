defmodule Yowed.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false
      add :body, :text
      add :subject, :string
      add :from, :map

      ref_projects = references(:projects, type: :binary_id, on_delete: :delete_all)
      add :project_id, ref_projects, null: false

      timestamps()
    end

    create index(:templates, [:project_id])
    create unique_index(:templates, [:project_id, :name])
  end
end
