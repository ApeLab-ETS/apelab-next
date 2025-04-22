defmodule Apelab.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :start_date, :utc_datetime, null: false
      add :end_date, :utc_datetime, null: false
      add :location, :string, null: false
      add :max_participants, :integer
      add :status, :string, null: false
      add :tags, {:array, :string}
      add :image_url, :string
      add :latitude, :float
      add :longitude, :float
      add :is_public, :boolean, default: true
      add :organizer_id, references(:users, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:events, [:organizer_id])
    create index(:events, [:status])
    create index(:events, [:start_date])
  end
end
