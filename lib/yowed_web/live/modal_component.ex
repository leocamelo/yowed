defmodule YowedWeb.ModalComponent do
  use YowedWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="modal is-active"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>
      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="box">
          <%= live_component @socket, @component, @opts %>
        </div>
      </div>
      <%= live_patch nil,
        to: @return_to,
        class: "modal-close is-large",
        aria: [label: "close"] %>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
