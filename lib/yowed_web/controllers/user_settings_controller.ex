defmodule YowedWeb.UserSettingsController do
  use YowedWeb, :controller

  alias Yowed.Accounts
  alias YowedWeb.UserAuth

  plug :put_layout, "app_blank.html"
  plug :assign_profile_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update_profile(conn, %{"user" => user_params}) do
    case Accounts.update_user_profile(conn.assigns.current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated successfully")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", profile_changeset: changeset)
    end
  end

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    case Accounts.update_user_password(conn.assigns.current_user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.login_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_profile_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
