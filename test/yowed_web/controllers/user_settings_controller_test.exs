defmodule YowedWeb.UserSettingsControllerTest do
  use YowedWeb.ConnCase, async: true

  alias Yowed.Accounts

  setup :register_and_login_user

  describe "GET /settings" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, Routes.user_settings_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ ">Settings</h1>"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.user_settings_path(conn, :edit))
      assert redirected_to(conn) == "/login"
    end
  end

  describe "PUT /settings/update_profile" do
    @tag :capture_log
    test "updates the user profile", %{conn: conn, user: user} do
      user_params = string_params_for(:user)

      conn =
        put(conn, Routes.user_settings_path(conn, :update_profile), %{
          "user" => user_params
        })

      assert redirected_to(conn) == "/settings"
      assert get_flash(conn, :info) =~ "Profile updated successfully"

      refute Accounts.get_user_by_email(user.email)
      assert Accounts.get_user_by_email(user_params["email"])
    end

    test "does not update profile on invalid data", %{conn: conn} do
      conn =
        put(conn, Routes.user_settings_path(conn, :update_profile), %{
          "user" => %{"name" => nil, "email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ ">Settings</h1>"
      assert response =~ "must have the @ sign and no spaces"
    end
  end

  describe "PUT /settings/update_password" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, Routes.user_settings_path(conn, :update_password), %{
          "current_password" => "ultrasecretpassword",
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == "/settings"
      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"

      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.user_settings_path(conn, :update_password), %{
          "current_password" => "invalid",
          "user" => %{
            "password" => "short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ ">Settings</h1>"
      assert response =~ "should be at least 8 character(s)"
      assert response =~ "does not match password"
      assert response =~ "is not valid"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end
end
