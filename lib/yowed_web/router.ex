defmodule YowedWeb.Router do
  use YowedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]

    plug :fetch_session
    plug :fetch_live_flash

    plug :put_root_layout, {YowedWeb.LayoutView, :root}

    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :fetch_current_user
  end

  scope "/", YowedWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/signup", UserRegistrationController, :new
    post "/signup", UserRegistrationController, :create

    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create

    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create

    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", YowedWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: YowedWeb.Telemetry
    end
  end

  scope "/", YowedWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", UserSettingsController, :edit
    put "/settings/update_password", UserSettingsController, :update_password
    put "/settings/update_email", UserSettingsController, :update_email

    live "/", ProjectLive.Index, :index
    live "/new", ProjectLive.Index, :new
    live "/:id", ProjectLive.Show, :show
    live "/:id/edit", ProjectLive.Show, :edit

    live "/:project_id/templates", TemplateLive.Index, :index
    live "/:project_id/templates/new", TemplateLive.Index, :new
    live "/:project_id/templates/:id", TemplateLive.Index, :preview
    live "/:project_id/templates/:id/edit", TemplateLive.Show, :edit
  end
end
