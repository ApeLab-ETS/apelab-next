defmodule Apelab.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string
    field :avatar_url, :string
    field :role, Ecto.Enum, values: [:admin, :organizer, :user]
    field :notification_preferences, :map, default: %{
      email: true,
      push: false
    }
    field :entra_id, :string

    has_many :organized_events, Apelab.Events.Event, foreign_key: :organizer_id
    has_many :participations, Apelab.Events.Participation
    has_many :participating_events, through: [:participations, :event]
    has_many :comments, Apelab.Events.Comment

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :first_name, :last_name, :avatar_url, :role, 
                    :notification_preferences, :entra_id])
    |> validate_required([:email, :first_name, :last_name, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_inclusion(:role, [:admin, :organizer, :user])
    |> unique_constraint(:email)
    |> unique_constraint(:entra_id)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end
  defp maybe_hash_password(changeset), do: changeset
end 