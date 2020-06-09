defmodule YowedWeb.LayoutView do
  use YowedWeb, :view

  alias Yowed.Accounts.User

  @spec gravatar_src(User.t(), integer) :: String.t()
  def gravatar_src(%User{email: email, name: name}, size) do
    "https://secure.gravatar.com/avatar/#{gravatar_email_hash(email)}?"
    |> Kernel.<>(URI.encode_query(s: size, d: gravatar_default_url(name, size)))
  end

  @spec gravatar_email_hash(String.t()) :: String.t()
  defp gravatar_email_hash(email) do
    :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
  end

  @spec gravatar_default_url(String.t(), integer) :: String.t()
  defp gravatar_default_url(name, size) do
    "https://ui-avatars.com/api/#{name}/#{size}"
  end
end
