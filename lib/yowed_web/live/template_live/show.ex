defmodule YowedWeb.TemplateLive.Show do
  use YowedWeb, :live_view

  alias Yowed.Crafts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(%{"project_id" => project_id, "id" => id}, _, socket) do
    project = Crafts.get_project!(socket.assigns.current_user, project_id)
    template = Crafts.get_template!(project, id)

    {:noreply,
     socket
     |> assign(:page_title, "Edit #{template.name}")
     |> assign(:project, project)
     |> assign(:template, template)}
  end
end
