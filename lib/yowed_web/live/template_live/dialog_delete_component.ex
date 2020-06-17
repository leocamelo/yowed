defmodule YowedWeb.TemplateLive.DialogDeleteComponent do
  use YowedWeb, :live_component

  alias Yowed.Crafts

  @impl true
  def handle_event("delete", _params, socket) do
    {:ok, _} = Crafts.delete_template(socket.assigns.template)

    {:noreply,
     socket
     |> put_flash(:info, "Template deleted successfully")
     |> push_redirect(
       to: Routes.template_index_path(socket, :index, socket.assigns.template.project_id),
       replace: true
     )}
  end
end
