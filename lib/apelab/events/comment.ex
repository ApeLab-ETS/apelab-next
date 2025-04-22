defmodule Apelab.Events.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :rating, :integer

    belongs_to :user, Apelab.Accounts.User
    belongs_to :event, Apelab.Events.Event

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :rating, :user_id, :event_id])
    |> validate_required([:content, :user_id, :event_id])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:event_id)
  end
end 