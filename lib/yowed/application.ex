defmodule Yowed.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Yowed.Repo,
      YowedWeb.Telemetry,
      {Phoenix.PubSub, name: Yowed.PubSub},
      YowedWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Yowed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    YowedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
