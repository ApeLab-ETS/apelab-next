defmodule ApelabWeb.AuthController do
  use ApelabWeb, :controller

  alias Apelab.Auth

  def login(conn, _params) do
    redirect(conn, external: Auth.authorization_url())
  end

  def callback(conn, %{"code" => code, "state" => state}) do
    case Auth.exchange_code_for_token(code) do
      {:ok, token} ->
        case Auth.verify_token(token.access_token) do
          {:ok, claims} ->
            conn
            |> put_session(:user_id, claims["sub"])
            |> put_session(:user_email, claims["email"])
            |> put_session(:user_name, claims["name"])
            |> put_flash(:info, "Login effettuato con successo")
            |> redirect(to: ~p"/")

          {:error, _reason} ->
            conn
            |> put_flash(:error, "Errore durante la verifica del token")
            |> redirect(to: ~p"/login")
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Errore durante l'autenticazione")
        |> redirect(to: ~p"/login")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "Parametri di callback non validi")
    |> redirect(to: ~p"/login")
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logout effettuato con successo")
    |> redirect(to: ~p"/")
  end
end
