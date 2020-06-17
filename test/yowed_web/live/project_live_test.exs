defmodule YowedWeb.ProjectLiveTest do
  use YowedWeb.ConnCase

  import Phoenix.LiveViewTest

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_project(_) do
    project = insert(:project)
    %{project: project}
  end

  describe "Index" do
    setup [:create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} =
        conn
        |> login_user(project.user)
        |> live(Routes.project_index_path(conn, :index))

      assert html =~ ">Select a project to work on</h1>"
      assert html =~ project.name
    end

    test "saves new project", %{conn: conn, project: project} do
      conn = login_user(conn, project.user)
      {:ok, index_live, _html} = live(conn, Routes.project_index_path(conn, :index))

      assert index_live
             |> element("a", "create a new one")
             |> render_click() =~ ">New project</h2>"

      assert_patch(index_live, Routes.project_index_path(conn, :new))

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ "Project created successfully"
      assert html =~ "some name"
    end
  end

  describe "Show" do
    setup [:create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} =
        conn
        |> login_user(project.user)
        |> live(Routes.project_show_path(conn, :show, project))

      assert html =~ ">#{project.name}</h1>"
    end

    test "updates project within modal", %{conn: conn, project: project} do
      conn = login_user(conn, project.user)
      {:ok, show_live, _html} = live(conn, Routes.project_show_path(conn, :show, project))

      assert show_live
             |> element("a", "Edit project")
             |> render_click() =~ ">Edit project</h2>"

      assert_patch(show_live, Routes.project_show_path(conn, :edit, project))

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.project_show_path(conn, :show, project))

      assert html =~ "Project updated successfully"
      assert html =~ "some updated name"
    end
  end
end
