defmodule Apelab.Repo.Migrations.CreateParticipations do
  use Ecto.Migration

  def change do
    create table(:participations) do
      add :status, :string, null: false
      add :notes, :text
      add :check_in_time, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:participations, [:user_id])
    create index(:participations, [:event_id])
    create unique_index(:participations, [:user_id, :event_id], name: :participations_user_id_event_id_index)
  end
end
