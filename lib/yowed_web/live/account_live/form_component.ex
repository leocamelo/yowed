defmodule YowedWeb.AccountLive.FormComponent do
  use YowedWeb, :live_component

  alias Yowed.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:email_changeset, email_changeset)
     |> assign(:password_changeset, password_changeset)}
  end
end
