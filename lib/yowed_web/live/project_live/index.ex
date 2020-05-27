defmodule YowedWeb.ProjectLive.Index do
  use YowedWeb, :live_view

  alias Yowed.Crafts
  alias Yowed.Crafts.Project

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(socket, session)
    {:ok, assign(socket, projects: Crafts.list_projects(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
  end
end
