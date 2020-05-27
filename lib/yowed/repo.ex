defmodule Yowed.Repo do
  use Ecto.Repo,
    otp_app: :yowed,
    adapter: Ecto.Adapters.Postgres

  def unload(struct, field, cardinality \\ :one) do
    %{
      struct
      | field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
    }
  end
end
