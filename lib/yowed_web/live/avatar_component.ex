defmodule YowedWeb.AvatarComponent do
  use YowedWeb, :live_component

  alias Yowed.Accounts.User

  @impl true
  def render(assigns) do
    ~L"""
      <figure class="image is-<%= @size %>x<%= @size %>">
        <img class="is-rounded" src="<%= image_src(@user, @size * 2) %>">
      </figure>
    """
  end

  @spec image_src(User.t(), integer) :: String.t()
  defp image_src(%User{email: email, name: name}, size) do
    "https://secure.gravatar.com/avatar/#{email_hash(email)}?"
    |> Kernel.<>(URI.encode_query(s: size, d: default_url(name, size)))
  end

  @spec email_hash(String.t()) :: String.t()
  defp email_hash(email) do
    :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
  end

  @spec default_url(String.t(), integer) :: String.t()
  defp default_url(name, size) do
    "https://ui-avatars.com/api/#{name}/#{size}"
  end
end
