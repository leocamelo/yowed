defmodule Yowed.Embed do
  @path "priv/embed"

  @type nodejs_module :: String.t() | {String.t(), atom}

  @doc false
  @spec call(nodejs_module, list) :: {:ok | :error, term}
  def call(module, args), do: NodeJS.call(module, args)

  @doc false
  @spec child_spec(Keyword.t()) :: Supervisor.child_spec()
  def child_spec(_opts) do
    %{
      id: NodeJS,
      start: {NodeJS, :start_link, [[path: @path]]},
      type: :supervisor
    }
  end
end
