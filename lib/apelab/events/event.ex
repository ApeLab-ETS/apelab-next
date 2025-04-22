defmodule Apelab.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :location, :string
    field :max_participants, :integer
    field :status, Ecto.Enum, values: [:planned, :in_progress, :completed, :cancelled]
    field :tags, {:array, :string}
    field :image_url, :string
    field :latitude, :float
    field :longitude, :float
    field :is_public, :boolean, default: true

    belongs_to :organizer, Apelab.Accounts.User
    has_many :participations, Apelab.Events.Participation
    has_many :participants, through: [:participations, :user]
    has_many :comments, Apelab.Events.Comment

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :start_date, :end_date, :location, :max_participants, 
                    :status, :tags, :image_url, :latitude, :longitude, :is_public, :organizer_id])
    |> validate_required([:title, :description, :start_date, :end_date, :location, :organizer_id])
    |> validate_number(:max_participants, greater_than: 0)
    |> validate_dates()
    |> foreign_key_constraint(:organizer_id)
  end

  defp validate_dates(changeset) do
    case {get_field(changeset, :start_date), get_field(changeset, :end_date)} do
      {start_date, end_date} when not is_nil(start_date) and not is_nil(end_date) ->
        if DateTime.compare(start_date, end_date) == :lt do
          changeset
        else
          add_error(changeset, :end_date, "must be after start date")
        end
      _ ->
        changeset
    end
  end
end 