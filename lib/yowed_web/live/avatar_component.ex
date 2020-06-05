defmodule YowedWeb.AvatarComponent do
  use YowedWeb, :live_component

  @impl true
  def render(%{user: user, size: size} = assigns) do
    hash =
      :crypto.hash(:md5, user.email)
      |> Base.encode16(case: :lower)

    default =
      "https://ui-avatars.com/api/#{user.email}/#{size * 2}"
      |> URI.encode_www_form()

    src = "https://secure.gravatar.com/avatar/#{hash}?s=#{size * 2}&d=#{default}"

    ~L"""
      <figure class="image is-<%= size %>x<%= size %>">
        <img class="is-rounded" src="<%= src %>">
      </figure>
    """
  end
end
