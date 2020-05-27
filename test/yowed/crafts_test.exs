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
      project_without_user = project |> Repo.unload(:user)

      assert Crafts.list_projects(project.user) == [project_without_user]
    end

    test "get_project!/2 returns the project with given id" do
      project = insert(:project)
      project_without_user = project |> Repo.unload(:user)

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
      assert Repo.unload(project, :user) == Crafts.get_project!(project.user, project.id)
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
end
