defmodule YowedWeb.AccountLive.Show do
  use YowedWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Account")
     |> assign(:project, nil)}
  end
end
