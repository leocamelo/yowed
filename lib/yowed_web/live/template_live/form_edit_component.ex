defmodule YowedWeb.TemplateLive.FormEditComponent do
  use YowedWeb, :live_component

  alias Yowed.Crafts

  @impl true
  def update(%{template: template} = assigns, socket) do
    changeset = Crafts.change_template(template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"template" => template_params}, socket) do
    changeset =
      socket.assigns.template
      |> Crafts.change_template(template_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"template" => template_params}, socket) do
    case Crafts.update_template(socket.assigns.template, template_params) do
      {:ok, template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Template updated successfully")
         |> push_patch(
           to: Routes.template_show_path(socket, :edit, template.project_id, template)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
