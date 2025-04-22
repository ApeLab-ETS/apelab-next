defmodule ApelabWeb.Admin.SessionController do
  use ApelabWeb, :controller

  alias Apelab.Accounts

  def new(conn, _params) do
    render(conn, :new, form: %{})
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_admin(email, password) do
      {:ok, admin} ->
        conn
        |> put_session(:admin_id, admin.id)
        |> put_flash(:info, "Benvenuto!")
        |> redirect(to: ~p"/admin/events")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Email o password non validi")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logout effettuato con successo")
    |> redirect(to: ~p"/admin/login")
  end
end
