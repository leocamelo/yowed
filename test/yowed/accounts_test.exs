defmodule Yowed.AccountsTest do
  use Yowed.DataCase

  alias Yowed.Accounts
  alias Yowed.Accounts.{User, UserToken}

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = insert(:user)
      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = insert(:user)
      refute Accounts.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      password = "ultrasecretpassword"
      %{id: id} = user = insert(:user, password: password)
      assert %User{id: ^id} = Accounts.get_user_by_email_and_password(user.email, password)
    end
  end

  describe "create_user_registration/1" do
    test "requires name, email and password to be set" do
      {:error, changeset} = Accounts.create_user_registration(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"],
               name: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} =
        Accounts.create_user_registration(%{email: "invalid", password: "invalid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 8 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for name, email and password for security" do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.create_user_registration(%{name: too_long, email: too_long, password: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).name
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = insert(:user)
      {:error, changeset} = Accounts.create_user_registration(%{email: email})

      assert "has already been taken" in errors_on(changeset).email

      {:error, changeset} = Accounts.create_user_registration(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers users with a hashed password" do
      params = params_for(:user) |> Map.put(:password, "ultrasecretpassword")
      {:ok, user} = Accounts.create_user_registration(params)

      assert user.email == params.email
      assert is_binary(user.name)
      assert is_binary(user.hashed_password)
      assert is_nil(user.password)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:password, :email, :name]
    end
  end

  describe "change_user_profile/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_profile(%User{})
      assert changeset.required == [:email, :name]
    end
  end

  describe "update_user_profile/2" do
    setup do
      user = insert(:user)
      %{name: name, email: email} = params_for(:user)

      %{user: user, name: name, email: email}
    end

    test "validates name", %{user: user} do
      {:error, changeset} = Accounts.update_user_profile(user, %{name: nil})
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} = Accounts.update_user_profile(user, %{email: "not valid"})
      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.update_user_profile(user, %{email: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{user: user} do
      %{email: email} = insert(:user)
      {:error, changeset} = Accounts.update_user_profile(user, %{email: email})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "updates the profile", %{user: user, name: name, email: email} do
      {:ok, _updated_user} = Accounts.update_user_profile(user, %{name: name, email: email})
      updated_user = Repo.get!(User, user.id)
      assert updated_user.email != user.email
      assert updated_user.email == email
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:password]
    end
  end

  describe "update_user_password/3" do
    setup do
      password = "ultrasecretpassword"
      user = insert(:user, password: password)

      %{user: user, password: password}
    end

    test "validates password", %{user: user, password: password} do
      {:error, changeset} =
        Accounts.update_user_password(user, password, %{
          password: "invalid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 8 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user, password: password} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.update_user_password(user, password, %{password: too_long})
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, "invalid", %{password: "new valid password"})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user, password: password} do
      {:ok, user} =
        Accounts.update_user_password(user, password, %{password: "new valid password"})

      assert is_nil(user.password)
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user, password: password} do
      _ = Accounts.generate_user_session_token(user)
      {:ok, _} = Accounts.update_user_password(user, password, %{password: "new valid password"})
      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: insert(:user)}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)

      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: insert(:user).id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = insert(:user)
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = insert(:user)
      token = Accounts.generate_user_session_token(user)

      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      user = insert(:user)

      {:ok, response} =
        Accounts.deliver_user_reset_password_instructions(user, &"[TOKEN]#{&1}[TOKEN]")

      [_, token, _] = String.split(response.body, "[TOKEN]")

      %{user: user, token: token}
    end

    test "sends token through notification", %{user: user, token: token} do
      {:ok, token} = Base.url_decode64(token, padding: false)

      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/2" do
    setup do
      user = insert(:user)

      {:ok, response} =
        Accounts.deliver_user_reset_password_instructions(user, &"[TOKEN]#{&1}[TOKEN]")

      [_, token, _] = String.split(response.body, "[TOKEN]")

      %{user: user, token: token}
    end

    test "returns the user with valid token", %{user: %{id: id}, token: token} do
      assert %User{id: ^id} = Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: id)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Accounts.get_user_by_reset_password_token("oops")
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "reset_user_password/3" do
    setup do
      %{user: insert(:user)}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.reset_user_password(user, %{
          password: "invalid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 8 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.reset_user_password(user, %{password: too_long})
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{user: user} do
      {:ok, updated_user} = Accounts.reset_user_password(user, %{password: "new valid password"})
      assert is_nil(updated_user.password)
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)
      {:ok, _} = Accounts.reset_user_password(user, %{password: "new valid password"})
      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
