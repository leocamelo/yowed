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
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Templates")
  end

  defp apply_action(socket, :new, _params) do
    assign(socket, :page_title, "New template")
  end

  defp apply_action(socket, :preview, %{"id" => id}) do
    template = Crafts.get_template!(socket.assigns.project, id)

    socket
    |> assign(:page_title, "Template preview")
    |> assign(:template, template)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} =
      socket.assigns.project
      |> Crafts.get_template!(id)
      |> Crafts.delete_template()

    {:noreply, assign(socket, :templates, list_templates(socket))}
  end

  defp assign_project(socket, project_id) do
    project = Crafts.get_project!(socket.assigns.current_user, project_id)
    assign(socket, :project, project)
  end

  defp list_templates(socket) do
    Crafts.list_templates(socket.assigns.project)
  end
end
