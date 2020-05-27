defmodule YowedWeb.ProjectLive.Show do
  use YowedWeb, :live_view

  alias Yowed.Crafts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Crafts.get_project!(socket.assigns.current_user, id))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
