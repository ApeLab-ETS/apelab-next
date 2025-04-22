defmodule Apelab.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ApelabWeb.Telemetry,
      Apelab.Repo,
      {DNSCluster, query: Application.get_env(:apelab, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Apelab.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Apelab.Finch},
      # Start a worker by calling: Apelab.Worker.start_link(arg)
      # {Apelab.Worker, arg},
      # Start to serve requests, typically the last entry
      ApelabWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apelab.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ApelabWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
