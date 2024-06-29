defmodule Yowed.Repo do
  use Ecto.Repo,
    otp_app: :yowed,
    adapter: Ecto.Adapters.Postgres
end
