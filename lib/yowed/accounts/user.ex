defmodule Yowed.Accounts.User do
  use Yowed, :schema

  alias Yowed.Crafts.Project

  @derive {Inspect, except: [:password]}
  schema "users" do
    field :name, :string
    field :email, :string

    field :password, :string, virtual: true
    field :hashed_password, :string

    has_many :projects, Project

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_name()
    |> validate_email()
    |> validate_password()
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, max: 160)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Yowed.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 80)
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  A user changeset for editiong the profile.

  It requires the email to change otherwise an error is added.
  """
  def profile_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_name()
    |> validate_email()
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%__MODULE__{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
