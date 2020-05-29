defmodule YowedWeb.UserRegistrationControllerTest do
  use YowedWeb.ConnCase, async: true

  describe "GET /signup" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ ">Sign Up</h1>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> login_user(insert(:user)) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /signup" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      params = params_for(:user)

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => params.email,
            "name" => params.name,
            "password" => "ultrasecretpassword"
          }
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)

      assert response =~ params.email
      assert response =~ ">Account</a>"
      assert response =~ ">Log Out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ ">Sign Up</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
