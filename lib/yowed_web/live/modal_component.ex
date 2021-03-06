defmodule YowedWeb.ModalComponent do
  use YowedWeb, :live_component

  @impl true
  def render(assigns) do
    size = Keyword.get(assigns.opts, :size, :normal)
    title = Keyword.get(assigns.opts, :title)

    ~L"""
    <div id="<%= @id %>" class="modal is-<%= size %>"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-hook="modal"
      phx-page-loading>
      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="box">
          <%= if title do %>
            <h2 class="title is-4"><%= title %></h2>
          <% end %>
          <%= live_component @socket, @component, @opts %>
        </div>
        <button type="button"
          class="close delete is-medium"
          aria-label="close">
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _params, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
