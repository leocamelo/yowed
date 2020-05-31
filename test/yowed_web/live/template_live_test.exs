defmodule YowedWeb.TemplateLiveTest do
  use YowedWeb.ConnCase

  import Phoenix.LiveViewTest

  defp create_template(_) do
    project = insert(:project)
    template = insert(:template, project: project)
    %{project: project, template: template}
  end

  describe "Index" do
    setup [:create_template]

    test "lists all templates", %{conn: conn, project: project, template: template} do
      {:ok, _index_live, html} =
        conn
        |> login_user(project.user)
        |> live(Routes.template_index_path(conn, :index, project))

      assert html =~ "Templates"
      assert html =~ template.name
    end

    test "saves new template", %{conn: conn, project: project} do
      conn = login_user(conn, project.user)
      {:ok, index_live, _html} = live(conn, Routes.template_index_path(conn, :index, project))

      assert index_live
             |> element("a", "Create a new template")
             |> render_click() =~ "New template"

      assert_patch(index_live, Routes.template_index_path(conn, :new, project))

      assert index_live
             |> form("#template-form", template: %{name: nil})
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#template-form", template: %{name: "some name"})
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ "Template created successfully"
      assert html =~ "some name"
    end

    test "displays template", %{conn: conn, project: project, template: template} do
      {:ok, _show_live, html} =
        conn
        |> login_user(project.user)
        |> live(Routes.template_index_path(conn, :preview, project, template))

      assert html =~ template.name
    end

    # test "deletes template in listing", %{conn: conn, project: project, template: template} do
    #   conn = login_user(conn, project.user)
    #   {:ok, index_live, _html} = live(conn, Routes.template_index_path(conn, :index, project))

    #   assert index_live |> element("#template-#{template.id} a", "Delete") |> render_click()
    #   refute has_element?(index_live, "#template-#{template.id}")
    # end
  end

  describe "Show" do
    setup [:create_template]

    test "updates template", %{conn: conn, project: project, template: template} do
      conn = login_user(conn, project.user)

      {:ok, show_live, _html} =
        live(conn, Routes.template_show_path(conn, :edit, project, template))

      assert show_live
             |> form("#template-form", template: %{name: nil, body: nil})
             |> render_change() =~ "can&apos;t be blank"

      # TODO: verify patch problem
      # html =
      #   show_live
      #   |> form("#template-form", template: @valid_update_attrs)
      #   |> render_submit()

      # assert html =~ "Template updated successfully"
      # assert html =~ "some updated name"
    end
  end
end
