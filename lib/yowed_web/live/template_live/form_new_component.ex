defmodule YowedWeb.TemplateLive.FormNewComponent do
  use YowedWeb, :live_component

  alias Yowed.Crafts
  alias Yowed.Crafts.Template

  @impl true
  def update(assigns, socket) do
    template = %Template{}
    changeset = Crafts.change_template(template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:template, template)
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
    case Crafts.create_template(socket.assigns.project, put_default_body(template_params)) do
      {:ok, template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Template created successfully")
         |> push_redirect(
           to: Routes.template_show_path(socket, :edit, template.project_id, template)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_default_body(params) do
    params
    |> Map.put(
      "body",
      String.trim("""
      <mjml>
        <mj-body>
          <mj-section>
            <mj-column>
              <mj-image width="100px" src="https://mjml.io/assets/img/logo-small.png"></mj-image>

              <mj-divider border-color="#F45E43"></mj-divider>

              <mj-text font-size="20px" color="#F45E43">Hello World</mj-text>
            </mj-column>
          </mj-section>
        </mj-body>
      </mjml>
      """)
    )
  end
end
