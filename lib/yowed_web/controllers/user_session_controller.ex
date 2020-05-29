defmodule YowedWeb.UserSessionController do
  use YowedWeb, :controller

  alias Yowed.Accounts
  alias YowedWeb.UserAuth

  def new(conn, _params) do
    conn |> assign_page_title() |> render("new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      conn
      |> assign_page_title()
      |> render("new.html", error_message: "Invalid e-mail or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.logout_user()
  end

  defp assign_page_title(conn) do
    assign(conn, :page_title, "Log In")
  end
end
