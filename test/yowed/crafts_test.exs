defmodule Yowed.CraftsTest do
  use Yowed.DataCase

  alias Yowed.Crafts

  describe "projects" do
    alias Yowed.Crafts.Project

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_projects/1 returns all projects" do
      project = insert(:project)
      project_without_user = project |> unload_assoc(:user)

      assert Crafts.list_projects(project.user) == [project_without_user]
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

      assert {:error, %Ecto.Changeset{}} = Crafts.create_project(user, @invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = insert(:project)

      assert {:ok, %Project{} = project} = Crafts.update_project(project, @update_attrs)
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = insert(:project)

      assert {:error, %Ecto.Changeset{}} = Crafts.update_project(project, @invalid_attrs)
      assert unload_assoc(project, :user) == Crafts.get_project!(project.user, project.id)
    end

    test "delete_project/1 deletes the project" do
      project = insert(:project)

      assert {:ok, %Project{}} = Crafts.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Crafts.get_project!(project.user, project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = build(:project)

      assert %Ecto.Changeset{} = Crafts.change_project(project)
    end
  end

  describe "templates" do
    alias Yowed.Crafts.Template

    @valid_attrs %{
      name: "some name",
      subject: "some subject",
      from: %{
        name: "some name",
        email: "some email"
      },
      body: """
        <mjml>
          <mj-body>
            <mj-section>
              <mj-column>
                <mj-text>
                  some body
                </mj-text>
              </mj-column>
            </mj-section>
          </mj-body>
        </mjml>
      """
    }

    @update_attrs %{
      name: "some updated name",
      subject: "some updated subject",
      from: %{
        name: "some updated name",
        email: "some updated email"
      },
      body: """
        <mjml>
          <mj-body>
            <mj-section>
              <mj-column>
                <mj-text>
                  some updated body
                </mj-text>
              </mj-column>
            </mj-section>
          </mj-body>
        </mjml>
      """
    }

    @invalid_attrs %{name: nil, body: nil, subject: nil, from: nil}

    test "list_templates/1 returns all templates" do
      template = insert(:template)

      [%{id: template_id, name: template_name} | []] = Crafts.list_templates(template.project)

      assert template_id == template.id
      assert template_name == template.name
    end

    test "get_template!/2 returns the template with given id" do
      template = insert(:template)
      template_without_project = template |> unload_assoc(:project)

      assert Crafts.get_template!(template.project, template.id) == template_without_project
    end

    test "create_template/1 with valid data creates a template" do
      project = insert(:project)

      assert {:ok, %Template{} = template} = Crafts.create_template(project, @valid_attrs)
      assert template.name == "some name"
      assert template.body =~ "some body"
      assert template.subject == "some subject"
      assert template.from.name == "some name"
      assert template.from.email == "some email"
    end

    test "create_template/1 with invalid data returns error changeset" do
      project = insert(:project)

      assert {:error, %Ecto.Changeset{}} = Crafts.create_template(project, @invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = insert(:template)

      assert {:ok, %Template{} = template} = Crafts.update_template(template, @update_attrs)
      assert template.name == "some updated name"
      assert template.body =~ "some updated body"
      assert template.subject == "some updated subject"
      assert template.from.name == "some updated name"
      assert template.from.email == "some updated email"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = insert(:template)

      assert {:error, %Ecto.Changeset{}} = Crafts.update_template(template, @invalid_attrs)

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

      assert %Ecto.Changeset{} = Crafts.change_template(template)
    end
  end
end
