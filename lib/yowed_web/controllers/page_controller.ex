defmodule YowedWeb.PageController do
  use YowedWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
