defmodule Yowed.Crafts.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  alias Yowed.Crafts.Contact

  embedded_schema do
    field :email, :string
    field :name, :string
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:name, :email])
  end
end
