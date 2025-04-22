# Implementazione Azure B2C in ApeLab

Questo documento descrive in dettaglio l'implementazione dell'autenticazione Azure B2C in ApeLab.

## Indice

- [Panoramica](#panoramica)
- [Prerequisiti](#prerequisiti)
- [Configurazione Azure B2C](#configurazione-azure-b2c)
- [Implementazione](#implementazione)
- [Configurazione Applicazione](#configurazione-applicazione)
- [Utilizzo](#utilizzo)
- [Sicurezza](#sicurezza)
- [Risoluzione Problemi](#risoluzione-problemi)

## Panoramica

Azure B2C è un servizio di gestione delle identità che permette di personalizzare e controllare come gli utenti si registrano, accedono e gestiscono i loro profili quando utilizzano le applicazioni. In ApeLab, Azure B2C viene utilizzato per:

- Registrazione utenti
- Autenticazione
- Gestione profili
- Recupero password
- Integrazione con provider di identità social

## Prerequisiti

- Tenant Azure B2C
- Applicazione registrata in Azure B2C
- Credenziali dell'applicazione (Client ID e Client Secret)
- Policy di registrazione e accesso configurate

## Configurazione Azure B2C

### 1. Creazione Tenant

1. Accedere al [portale Azure](https://portal.azure.com)
2. Creare un nuovo tenant B2C:
   ```
   Nome: apelab-tenant
   Nome iniziale del dominio: apelab.onmicrosoft.com
   Paese/Regione: Italy
   ```

### 2. Registrazione Applicazione

1. Nel tenant B2C, registrare una nuova applicazione:
   ```
   Nome: ApeLab
   Tipo di applicazione: Web app/API
   URL di risposta: https://apelab.example.com/auth/callback
   ```

2. Configurare le autorizzazioni:
   - OpenID
   - Email
   - Profile

### 3. Configurazione Policy

1. Creare policy di registrazione:
   ```
   Nome: B2C_1_signup
   Provider di identità: Email signup
   Attributi di registrazione: Email, Nome, Cognome
   ```

2. Creare policy di accesso:
   ```
   Nome: B2C_1_signin
   Provider di identità: Local account
   Attributi di accesso: Email
   ```

## Implementazione

### 1. Dipendenze

Aggiungere le dipendenze necessarie in `mix.exs`:

```elixir
defp deps do
  [
    {:azure_b2c, "~> 0.1.0"},
    {:jason, "~> 1.4"},
    {:plug_cowboy, "~> 2.6"}
  ]
end
```

### 2. Configurazione

Configurare Azure B2C in `config/config.exs`:

```elixir
config :apelab,
  azure_b2c_tenant: System.get_env("AZURE_B2C_TENANT"),
  azure_b2c_client_id: System.get_env("AZURE_B2C_CLIENT_ID"),
  azure_b2c_client_secret: System.get_env("AZURE_B2C_CLIENT_SECRET"),
  azure_b2c_policy: System.get_env("AZURE_B2C_POLICY"),
  azure_b2c_redirect_uri: System.get_env("AZURE_B2C_REDIRECT_URI")
```

### 3. Modulo Auth

Creare il modulo `lib/apelab/auth.ex`:

```elixir
defmodule Apelab.Auth do
  @moduledoc """
  Modulo per la gestione dell'autenticazione con Azure B2C.
  """

  def get_authorization_url do
    tenant = Application.get_env(:apelab, :azure_b2c_tenant)
    client_id = Application.get_env(:apelab, :azure_b2c_client_id)
    policy = Application.get_env(:apelab, :azure_b2c_policy)
    redirect_uri = Application.get_env(:apelab, :azure_b2c_redirect_uri)

    "https://#{tenant}.b2clogin.com/#{tenant}.onmicrosoft.com/#{policy}/oauth2/v2.0/authorize?" <>
      "client_id=#{client_id}&" <>
      "response_type=code&" <>
      "redirect_uri=#{redirect_uri}&" <>
      "response_mode=form_post&" <>
      "scope=openid profile email"
  end

  def get_token(code) do
    tenant = Application.get_env(:apelab, :azure_b2c_tenant)
    client_id = Application.get_env(:apelab, :azure_b2c_client_id)
    client_secret = Application.get_env(:apelab, :azure_b2c_client_secret)
    policy = Application.get_env(:apelab, :azure_b2c_policy)
    redirect_uri = Application.get_env(:apelab, :azure_b2c_redirect_uri)

    body = URI.encode_query(%{
      client_id: client_id,
      client_secret: client_secret,
      grant_type: "authorization_code",
      code: code,
      redirect_uri: redirect_uri
    })

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    case HTTPoison.post(
      "https://#{tenant}.b2clogin.com/#{tenant}.onmicrosoft.com/#{policy}/oauth2/v2.0/token",
      body,
      headers
    ) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:error, error} ->
        {:error, error}
    end
  end

  def get_user_info(access_token) do
    tenant = Application.get_env(:apelab, :azure_b2c_tenant)
    policy = Application.get_env(:apelab, :azure_b2c_policy)

    headers = [{"Authorization", "Bearer #{access_token}"}]

    case HTTPoison.get(
      "https://#{tenant}.b2clogin.com/#{tenant}.onmicrosoft.com/#{policy}/openid/userinfo",
      headers
    ) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:error, error} ->
        {:error, error}
    end
  end
end
```

### 4. Controller Auth

Creare il controller `lib/apelab_web/controllers/auth_controller.ex`:

```elixir
defmodule ApelabWeb.AuthController do
  use ApelabWeb, :controller

  def login(conn, _params) do
    auth_url = Apelab.Auth.get_authorization_url()
    redirect(conn, external: auth_url)
  end

  def callback(conn, %{"code" => code}) do
    case Apelab.Auth.get_token(code) do
      {:ok, %{"access_token" => access_token}} ->
        case Apelab.Auth.get_user_info(access_token) do
          {:ok, user_info} ->
            conn
            |> put_session(:current_user, user_info)
            |> put_flash(:info, "Accesso effettuato con successo")
            |> redirect(to: ~p"/")
          {:error, _reason} ->
            conn
            |> put_flash(:error, "Errore durante il recupero delle informazioni utente")
            |> redirect(to: ~p"/login")
        end
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Errore durante l'autenticazione")
        |> redirect(to: ~p"/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Disconnessione effettuata con successo")
    |> redirect(to: ~p"/")
  end
end
```

### 5. Router

Aggiungere le rotte in `lib/apelab_web/router.ex`:

```elixir
scope "/auth", ApelabWeb do
  pipe_through :browser

  get "/login", AuthController, :login
  post "/callback", AuthController, :callback
  delete "/logout", AuthController, :logout
end
```

## Configurazione Applicazione

### 1. Variabili d'Ambiente

Creare un file `.env` nella root del progetto:

```bash
AZURE_B2C_TENANT=apelab-tenant
AZURE_B2C_CLIENT_ID=your-client-id
AZURE_B2C_CLIENT_SECRET=your-client-secret
AZURE_B2C_POLICY=B2C_1_signin
AZURE_B2C_REDIRECT_URI=https://apelab.example.com/auth/callback
```

### 2. Plug di Autenticazione

Creare il plug `lib/apelab_web/plugs/auth_plug.ex`:

```elixir
defmodule ApelabWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if current_user = get_session(conn, :current_user) do
      assign(conn, :current_user, current_user)
    else
      conn
      |> put_flash(:error, "Devi effettuare l'accesso per accedere a questa pagina")
      |> redirect(to: ~p"/auth/login")
      |> halt()
    end
  end
end
```

## Utilizzo

### 1. Protezione delle Rotte

```elixir
scope "/admin", ApelabWeb do
  pipe_through [:browser, ApelabWeb.AuthPlug]

  # Rotte protette
end
```

### 2. Accesso all'Utente Corrente

```elixir
def index(conn, _params) do
  current_user = conn.assigns.current_user
  # ...
end
```

### 3. Template

```heex
<%= if @current_user do %>
  <div>
    Benvenuto, <%= @current_user["name"] %>!
    <%= link "Logout", to: ~p"/auth/logout", method: :delete %>
  </div>
<% else %>
  <%= link "Login", to: ~p"/auth/login" %>
<% end %>
```

## Sicurezza

### 1. CSRF Protection

Assicurarsi che la protezione CSRF sia abilitata in `lib/apelab_web/endpoint.ex`:

```elixir
plug :protect_from_forgery
plug :put_secure_browser_headers
```

### 2. Sessioni Sicure

Configurare le sessioni in modo sicuro in `config/config.exs`:

```elixir
config :apelab, ApelabWeb.Endpoint,
  session_options: [
    store: :cookie,
    key: "_apelab_key",
    signing_salt: "your-signing-salt",
    max_age: 60 * 60 * 24 * 7 # 1 settimana
  ]
```

### 3. Headers di Sicurezza

Aggiungere headers di sicurezza in `lib/apelab_web/endpoint.ex`:

```elixir
plug :put_secure_browser_headers, %{
  "content-security-policy" => "default-src 'self'",
  "x-frame-options" => "DENY",
  "x-content-type-options" => "nosniff",
  "x-xss-protection" => "1; mode=block"
}
```

## Risoluzione Problemi

### 1. Errori di Autenticazione

- Verificare che le credenziali Azure B2C siano corrette
- Controllare che l'URL di callback sia configurato correttamente
- Verificare che le policy siano attive e configurate correttamente

### 2. Errori CSRF

- Assicurarsi che il token CSRF sia incluso in tutte le richieste POST
- Verificare che la protezione CSRF sia configurata correttamente
- Controllare che le sessioni funzionino correttamente

### 3. Problemi di Sessione

- Verificare che le opzioni di sessione siano configurate correttamente
- Controllare che i cookie vengano impostati correttamente
- Verificare che non ci siano problemi con il dominio dei cookie

### 4. Logging

Aggiungere logging per il debug in `lib/apelab/auth.ex`:

```elixir
require Logger

def get_token(code) do
  Logger.debug("Richiesta token con code: #{code}")
  # ...
end
``` 