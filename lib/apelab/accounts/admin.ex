defmodule Apelab.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt.Base

  schema "admins" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :is_super_admin, :boolean, default: false

    timestamps()
  end

  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:email, :password, :name, :is_super_admin])
    |> validate_required([:email, :password, :name])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "deve essere un indirizzo email valido")
    |> validate_length(:password, min: 6, message: "deve essere lungo almeno 6 caratteri")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Base.hash_password(password, Base.gen_salt()))
  end

  defp put_password_hash(changeset), do: changeset
end
