defmodule Apelab.Events.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participations" do
    field :status, Ecto.Enum, values: [:pending, :confirmed, :declined]
    field :notes, :string
    field :check_in_time, :utc_datetime

    belongs_to :user, Apelab.Accounts.User
    belongs_to :event, Apelab.Events.Event

    timestamps()
  end

  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [:status, :notes, :check_in_time, :user_id, :event_id])
    |> validate_required([:status, :user_id, :event_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
    |> unique_constraint([:user_id, :event_id], name: :participations_user_id_event_id_index)
  end
end 