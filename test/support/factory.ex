defmodule Yowed.Factory do
  use ExMachina.Ecto, repo: Yowed.Repo

  alias Yowed.Accounts.User
  alias Yowed.Crafts.{Project, Template}

  def user_factory(attrs) do
    hashed_password =
      attrs
      |> Map.get(:password, "ultrasecretpassword")
      |> Bcrypt.hash_pwd_salt()

    user = %User{
      name: "Sophie",
      email: sequence(:user_email, &"sophie#{&1}@example.com"),
      hashed_password: hashed_password
    }

    merge_attributes(user, Map.delete(attrs, :password))
  end

  def project_factory do
    %Project{
      user: build(:user),
      name: sequence(:project_name, &"Philosophy #{&1}")
    }
  end

  def template_factory do
    %Template{
      project: build(:project),
      name: sequence(:template_name, &"Welcome email #{&1}"),
      subject: "Welcome to our philosofy class",
      from: %{
        name: "Sophie",
        email: "sophie@example.com"
      },
      body: """
        <mjml>
          <mj-body>
            <mj-section>
              <mj-column>
                <mj-text>
                  Welcome to our philosofy class
                </mj-text>
              </mj-column>
            </mj-section>
          </mj-body>
        </mjml>
      """
    }
  end
end
