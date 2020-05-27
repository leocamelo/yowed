defmodule Yowed.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string, null: false

      ref_users = references(:users, type: :binary_id, on_delete: :delete_all)
      add :user_id, ref_users, null: false

      timestamps()
    end

    create index(:projects, [:user_id])
    create unique_index(:projects, [:user_id, :name])
  end
end
