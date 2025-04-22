defmodule Apelab.Auth do
  @moduledoc """
  Modulo per la gestione dell'autenticazione con Azure B2C.
  """

  alias OAuth2.Client
  alias Joken.Signer

  @azure_b2c_tenant Application.compile_env(:apelab, :azure_b2c_tenant)
  @azure_b2c_client_id Application.compile_env(:apelab, :azure_b2c_client_id)
  @azure_b2c_client_secret Application.compile_env(:apelab, :azure_b2c_client_secret)
  @azure_b2c_policy Application.compile_env(:apelab, :azure_b2c_policy)

  @doc """
  Genera l'URL di autorizzazione per Azure B2C.
  """
  def authorization_url do
    params = [
      client_id: @azure_b2c_client_id,
      response_type: "code",
      redirect_uri: "#{ApelabWeb.Router.Helpers.url(ApelabWeb.Endpoint)}/auth/callback",
      response_mode: "query",
      scope: "openid profile email",
      state: generate_state()
    ]

    "https://#{@azure_b2c_tenant}.b2clogin.com/#{@azure_b2c_tenant}.onmicrosoft.com/#{@azure_b2c_policy}/oauth2/v2.0/authorize?#{URI.encode_query(params)}"
  end

  @doc """
  Scambia il codice di autorizzazione per un token di accesso.
  """
  def exchange_code_for_token(code) do
    client = Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: @azure_b2c_client_id,
      client_secret: @azure_b2c_client_secret,
      redirect_uri: "#{ApelabWeb.Router.Helpers.url(ApelabWeb.Endpoint)}/auth/callback",
      site: "https://#{@azure_b2c_tenant}.b2clogin.com/#{@azure_b2c_tenant}.onmicrosoft.com/#{@azure_b2c_policy}/oauth2/v2.0",
      authorize_url: "/authorize",
      token_url: "/token"
    ])

    case Client.get_token(client, code: code) do
      {:ok, %{token: token}} ->
        {:ok, token}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Verifica e decodifica il token JWT.
  """
  def verify_token(token) do
    signer = Signer.parse_jwk(@azure_b2c_client_secret)

    case Joken.verify(token, signer) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Genera uno stato casuale per la richiesta di autorizzazione.
  """
  defp generate_state do
    :crypto.strong_rand_bytes(32)
    |> Base.encode64()
    |> binary_part(0, 32)
  end
end
