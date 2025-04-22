defmodule Apelab.Accounts do
  alias Apelab.Repo
  alias Apelab.Accounts.Admin

  def list_admins do
    Repo.all(Admin)
  end

  def get_admin!(id), do: Repo.get!(Admin, id)

  def get_admin_by_email(email) do
    Repo.get_by(Admin, email: email)
  end

  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  def authenticate_admin(email, password) do
    admin = get_admin_by_email(email)

    cond do
      admin && Bcrypt.verify_pass(password, admin.password_hash) ->
        {:ok, admin}
      admin ->
        {:error, :unauthorized}
      true ->
        {:error, :not_found}
    end
  end
end
