defmodule Buckets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BucketsWeb.Telemetry,
      Buckets.Repo,
      {DNSCluster, query: Application.get_env(:buckets, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Buckets.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Buckets.Finch},
      # Start a worker by calling: Buckets.Worker.start_link(arg)
      # {Buckets.Worker, arg},
      # Start to serve requests, typically the last entry
      BucketsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Buckets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BucketsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
