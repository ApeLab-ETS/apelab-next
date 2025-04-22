import Phoenix.Router

defmodule ApelabWeb.Router do
  use ApelabWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ApelabWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_auth do
    plug :ensure_admin_authenticated
  end

  pipeline :auth do
    plug :ensure_authenticated
  end

  scope "/", ApelabWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about
    get "/events", EventController, :index
    get "/events/:id", EventController, :show
    get "/register", UserController, :new
    post "/register", UserController, :create
    get "/login", AuthController, :login
    get "/auth/callback", AuthController, :callback
    delete "/logout", AuthController, :logout
  end

  scope "/admin", ApelabWeb.Admin do
    pipe_through :browser

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    scope "/", as: :admin do
      pipe_through :admin_auth

      resources "/events", EventController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApelabWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:apelab, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ApelabWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp ensure_admin_authenticated(conn, _opts) do
    if admin_id = get_session(conn, :admin_id) do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Devi effettuare il login per accedere a questa pagina")
      |> Phoenix.Controller.redirect(to: "/admin/login")
      |> halt()
    end
  end

  defp ensure_authenticated(conn, _opts) do
    if user_id = get_session(conn, :user_id) do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Devi effettuare il login per accedere a questa pagina")
      |> Phoenix.Controller.redirect(to: "/login")
      |> halt()
    end
  end
end
