defmodule YowedWeb.ProjectLive.Show do
  use YowedWeb, :live_view

  alias Yowed.Crafts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    project = Crafts.get_project!(socket.assigns.current_user, id)

    {:noreply,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:project, project)}
  end
end
