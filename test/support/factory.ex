defmodule Yowed.Factory do
  use ExMachina.Ecto, repo: Yowed.Repo

  alias Yowed.Accounts.User
  alias Yowed.Crafts.{Message, Project, Template}

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
      from: %{name: "Sophie", email: "sophie@example.com"},
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

  def message_factory do
    %Message{
      project: build(:project),
      template: build(:template),
      from: %{name: "Sophie", email: "sophie@example.com"},
      reply_to: %{name: "Sophie", email: "sophie@example.com"},
      to: [%{name: "Hilde", email: "hilde@example.com"}],
      cc: [%{name: "Albert", email: "albert@example.com"}],
      bcc: [%{name: "Alberto", email: "alberto@example.com"}],
      subject: "Philosophy course",
      body_html: """
      <!doctype html>
      <html>
        <head>
          <title>Philosophy course</title>
        </head>
        <body>
          <h1>Welcome to our philosophy course!</h1>
        </body>
      </html>
      """,
      body_text: "Welcome to our philosophy course!",
      status: 0,
      provider: 0,
      provider_id: "42"
    }
  end
end
