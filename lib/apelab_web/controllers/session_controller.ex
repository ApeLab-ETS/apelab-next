defmodule ApelabWeb.SessionController do
  use ApelabWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"session" => session_params}) do
    # TODO: Implementare l'autenticazione dell'utente
    conn
    |> put_flash(:info, "Login effettuato con successo!")
    |> redirect(to: ~p"/")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logout effettuato con successo!")
    |> redirect(to: ~p"/")
  end
end
