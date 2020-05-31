defmodule YowedWeb.TemplateLive.FormEditComponent do
  use YowedWeb, :live_component

  alias Ecto.Changeset

  alias Yowed.Crafts

  @impl true
  def update(%{template: template} = assigns, socket) do
    changeset = Crafts.change_template(template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:template_preview, template)}
  end

  @impl true
  def handle_event("validate", %{"template" => template_params}, socket) do
    changeset =
      socket.assigns.template
      |> Crafts.change_template(template_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:template_preview, Changeset.apply_changes(changeset))}
  end

  def handle_event("save", %{"template" => template_params}, socket) do
    case Crafts.update_template(socket.assigns.template, template_params) do
      {:ok, template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Template updated successfully")
         |> push_redirect(
           to: Routes.template_show_path(socket, :edit, template.project_id, template),
           replace: true
         )}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
