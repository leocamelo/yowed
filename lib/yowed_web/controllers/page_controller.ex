defmodule YowedWeb.PageController do
  use YowedWeb, :controller

  def index(conn, _params) do
    html(conn, """
      <h1>Welcome Yowed!</h1>
      <p>#{conn.assigns.current_user.email}</p>
      <ul>
        <li><a href="/settings">Settings</a></li>
        <li><a href="/logout">Logout</a></li>
      </ul>
    """)
  end
end
