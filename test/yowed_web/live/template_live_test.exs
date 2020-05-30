defmodule YowedWeb.TemplateLiveTest do
  use YowedWeb.ConnCase

  import Phoenix.LiveViewTest

  @create_attrs %{name: "some name", body: "some body", subject: "some subject", from: %{}}
  @update_attrs %{
    name: "some updated name",
    body: "some updated body",
    subject: "some updated subject",
    from: %{}
  }
  @invalid_attrs %{name: nil, body: nil, subject: nil, from: nil}

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

      assert html =~ "Listing Templates"
      assert html =~ template.name
    end

    test "saves new template", %{conn: conn, project: project} do
      conn = login_user(conn, project.user)
      {:ok, index_live, _html} = live(conn, Routes.template_index_path(conn, :index, project))

      assert index_live
             |> element("a", "Create a new template")
             |> render_click() =~ "New Template"

      assert_patch(index_live, Routes.template_index_path(conn, :new, project))

      assert index_live
             |> form("#template-form", template: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#template-form", template: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.template_index_path(conn, :index, project))

      assert html =~ "Template created successfully"
      assert html =~ "some name"
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

    test "displays template", %{conn: conn, project: project, template: template} do
      {:ok, _show_live, html} =
        conn
        |> login_user(project.user)
        |> live(Routes.template_show_path(conn, :show, project, template))

      assert html =~ ">#{template.name}</h1>"
    end

    test "updates template within modal", %{conn: conn, project: project, template: template} do
      conn = login_user(conn, project.user)

      {:ok, show_live, _html} =
        live(conn, Routes.template_show_path(conn, :show, project, template))

      assert show_live
             |> element("a", "Edit template")
             |> render_click() =~ template.name

      assert_patch(show_live, Routes.template_show_path(conn, :edit, project, template))

      assert show_live
             |> form("#template-form", template: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#template-form", template: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.template_show_path(conn, :show, project, template))

      assert html =~ "Template updated successfully"
      assert html =~ "some updated name"
    end
  end
end
