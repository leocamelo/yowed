defmodule YowedWeb.TemplateLive.Index do
  use YowedWeb, :live_view

  alias Yowed.Crafts

  @impl true
  def mount(%{"project_id" => project_id}, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign_project(project_id)

    {:ok, assign(socket, :templates, list_templates(socket))}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    template = Crafts.get_template!(socket.assigns.project, id)

    {:noreply,
     socket
     |> assign(:template, template)
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :page_title, page_title(socket.assigns.live_action))}
  end

  defp assign_project(socket, project_id) do
    project = Crafts.get_project!(socket.assigns.current_user, project_id)
    assign(socket, :project, project)
  end

  defp list_templates(socket) do
    Crafts.list_templates(socket.assigns.project)
  end

  defp page_title(:index), do: "Templates"
  defp page_title(:new), do: "New template"
  defp page_title(:preview), do: "Template preview"
  defp page_title(:delete), do: "Delete template"
end
