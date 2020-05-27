defmodule Yowed.Factory do
  use ExMachina.Ecto, repo: Yowed.Repo

  alias Yowed.Accounts.User
  alias Yowed.Crafts.Project

  def user_factory do
    %User{
      name: "Sophie",
      email: sequence(:user_email, &"sophie#{&1}@example.com"),
      hashed_password: "ultrasecretpassword"
    }
  end

  def project_factory do
    %Project{
      user: build(:user),
      name: sequence(:project_name, &"Philosophy#{&1}")
    }
  end
end
