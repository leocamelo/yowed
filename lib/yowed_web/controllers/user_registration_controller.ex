defmodule YowedWeb.UserRegistrationController do
  use YowedWeb, :controller

  alias Yowed.Accounts
  alias Yowed.Accounts.User
  alias YowedWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    conn |> assign_page_title() |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user_registration(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully")
        |> UserAuth.login_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign_page_title()
        |> render("new.html", changeset: changeset)
    end
  end

  defp assign_page_title(conn) do
    assign(conn, :page_title, "Sign Up")
  end
end
