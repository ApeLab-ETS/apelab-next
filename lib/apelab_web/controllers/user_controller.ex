defmodule ApelabWeb.UserController do
  use ApelabWeb, :controller

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => user_params}) do
    # TODO: Implementare la creazione dell'utente
    conn
    |> put_flash(:info, "Registrazione completata con successo!")
    |> redirect(to: ~p"/")
  end
end
