defmodule Yowed.CraftsTest do
  use Yowed.DataCase

  alias Ecto.Changeset

  alias Yowed.Crafts

  describe "projects" do
    alias Yowed.Crafts.Project

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_projects/1 returns all projects" do
      project = insert(:project)

      [%{id: project_id, name: project_name}] = Crafts.list_projects(project.user)

      assert project_id == project.id
      assert project_name == project.name
    end

    test "get_project!/2 returns the project with given id" do
      project = insert(:project)
      project_without_user = project |> unload_assoc(:user)

      assert Crafts.get_project!(project.user, project.id) == project_without_user
    end

    test "create_project/2 with valid data creates a project" do
      user = insert(:user)

      assert {:ok, %Project{} = project} = Crafts.create_project(user, @valid_attrs)
      assert project.name == "some name"
      assert project.user_id == user.id
    end

    test "create_project/1 with invalid data returns error changeset" do
      user = insert(:user)

      assert {:error, %Changeset{}} = Crafts.create_project(user, @invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = insert(:project)

      assert {:ok, %Project{} = project} = Crafts.update_project(project, @update_attrs)
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = insert(:project)

      assert {:error, %Changeset{}} = Crafts.update_project(project, @invalid_attrs)
      assert unload_assoc(project, :user) == Crafts.get_project!(project.user, project.id)
    end

    test "delete_project/1 deletes the project" do
      project = insert(:project)

      assert {:ok, %Project{}} = Crafts.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Crafts.get_project!(project.user, project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = build(:project)

      assert %Changeset{} = Crafts.change_project(project)
    end
  end

  describe "templates" do
    alias Yowed.Crafts.Template

    @valid_attrs %{
      name: "some name",
      subject: "some subject",
      from: %{name: "some from name", email: "some from email"},
      body: "<mjml><mj-body>some body</mj-body></mjml>"
    }

    @update_attrs %{
      name: "some updated name",
      subject: "some updated subject",
      from: %{name: "some updated from name", email: "some updated from email"},
      body: "<mjml><mj-body>some updated body</mj-body></mjml>"
    }

    @invalid_attrs %{name: nil, body: nil, subject: nil, from: nil}

    test "list_templates/1 returns all templates" do
      template = insert(:template)

      [%{id: template_id, name: template_name}] = Crafts.list_templates(template.project)

      assert template_id == template.id
      assert template_name == template.name
    end

    test "get_template!/2 returns the template with given id" do
      template = insert(:template)
      template_without_assocs = template |> unload_assoc(:project)

      assert Crafts.get_template!(template.project, template.id) == template_without_assocs
    end

    test "create_template/2 with valid data creates a template" do
      project = insert(:project)

      assert {:ok, %Template{} = template} = Crafts.create_template(project, @valid_attrs)
      assert template.name == "some name"
      assert template.body =~ "some body"
      assert template.subject == "some subject"
      assert template.from.name == "some from name"
      assert template.from.email == "some from email"
    end

    test "create_template/2 with invalid data returns error changeset" do
      project = insert(:project)

      assert {:error, %Changeset{}} = Crafts.create_template(project, @invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = insert(:template)

      assert {:ok, %Template{} = template} = Crafts.update_template(template, @update_attrs)
      assert template.name == "some updated name"
      assert template.body =~ "some updated body"
      assert template.subject == "some updated subject"
      assert template.from.name == "some updated from name"
      assert template.from.email == "some updated from email"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = insert(:template)

      assert {:error, %Changeset{}} = Crafts.update_template(template, @invalid_attrs)

      assert unload_assoc(template, :project) ==
               Crafts.get_template!(template.project, template.id)
    end

    test "delete_template/1 deletes the template" do
      template = insert(:template)

      assert {:ok, %Template{}} = Crafts.delete_template(template)

      assert_raise Ecto.NoResultsError, fn ->
        Crafts.get_template!(template.project, template.id)
      end
    end

    test "change_template/1 returns a template changeset" do
      template = build(:template)

      assert %Changeset{} = Crafts.change_template(template)
    end
  end

  describe "messages" do
    alias Yowed.Crafts.Message

    @valid_attrs %{
      from: %{name: "some from name", email: "some from email"},
      reply_to: %{name: "some reply to name", email: "some reply to email"},
      to: [%{name: "some to name", email: "some to email"}],
      cc: [%{name: "some cc name", email: "some cc email"}],
      bcc: [%{name: "some bcc name", email: "some bcc email"}],
      subject: "some subject",
      body_html: "<html><body>some body html</body></html>",
      body_text: "some body text",
      provider: 0,
      provider_id: "some provider id"
    }

    @update_attrs %{
      subject: "some updated subject",
      body_html: "<html><body>some updated body html</body></html>",
      body_text: "some updated body text",
      status: 1,
      provider: 1,
      provider_id: "some updated provider id"
    }

    @invalid_attrs %{subject: nil, body_html: nil, body_text: nil}

    test "list_messages/1 returns all messages" do
      message = insert(:message)

      [%{id: message_id, subject: message_subject}] = Crafts.list_messages(message.project)

      assert message_id == message.id
      assert message_subject == message.subject
    end

    test "get_message! returns the message with gived id" do
      message = insert(:message)
      message_without_assocs = message |> unload_assoc(:project) |> unload_assoc(:template)

      assert Crafts.get_message!(message.project, message.id) == message_without_assocs
    end

    test "create_message/2 with valid data creates a message" do
      template = insert(:template)

      assert {:ok, %Message{} = message} = Crafts.create_message(template, @valid_attrs)
      assert message.from.name == "some from name"
      assert message.from.email == "some from email"
      assert message.reply_to.name == "some reply to name"
      assert message.reply_to.email == "some reply to email"
      assert hd(message.to).name == "some to name"
      assert hd(message.to).email == "some to email"
      assert hd(message.cc).name == "some cc name"
      assert hd(message.cc).email == "some cc email"
      assert hd(message.bcc).name == "some bcc name"
      assert hd(message.bcc).email == "some bcc email"
      assert message.subject == "some subject"
      assert message.body_html =~ "some body html"
      assert message.body_text == "some body text"
      assert message.status == 0
      assert message.provider == 0
      assert message.provider_id == "some provider id"
    end

    test "create_message/2 with invalid data returns error changeset" do
      template = insert(:template)

      assert {:error, %Changeset{}} = Crafts.create_message(template, @invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = insert(:message)

      assert {:ok, %Message{} = message} = Crafts.update_message(message, @update_attrs)
      assert message.subject == "some updated subject"
      assert message.body_html =~ "some updated body html"
      assert message.body_text == "some updated body text"
      assert message.status == 1
      assert message.provider == 1
      assert message.provider_id == "some updated provider id"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = insert(:message)

      assert {:error, %Changeset{}} = Crafts.update_message(message, @invalid_attrs)

      assert message |> unload_assoc(:project) |> unload_assoc(:template) ==
               Crafts.get_message!(message.project, message.id)
    end

    test "change_template/1 returns a message changeset" do
      message = build(:message)

      assert %Changeset{} = Crafts.change_message(message)
    end
  end
end
