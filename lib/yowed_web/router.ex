defmodule YowedWeb.Router do
  use YowedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]

    plug :fetch_session
    plug :fetch_live_flash

    plug :put_root_layout, {YowedWeb.LayoutView, :root}

    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", YowedWeb do
    pipe_through :browser
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: YowedWeb.Telemetry
    end
  end
end
