defmodule Apelab.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :avatar_url, :string
      add :role, :string, null: false
      add :notification_preferences, :map, default: %{}
      add :entra_id, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:entra_id])
  end
end
