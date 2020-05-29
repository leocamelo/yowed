defmodule YowedWeb.ProjectLive.Show do
  use YowedWeb, :live_view

  alias Yowed.Crafts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(%{"project_id" => project_id}, _, socket) do
    project = Crafts.get_project!(socket.assigns.current_user, project_id)

    {:noreply,
     socket
     |> assign(:page_title, project.name)
     |> assign(:project, project)}
  end
end
