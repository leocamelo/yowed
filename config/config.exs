use Mix.Config

config :yowed,
  ecto_repos: [Yowed.Repo],
  generators: [binary_id: true]

config :yowed, YowedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jVIC9IzQBSYBY+aEqGn+iUTd5pectaWfg1FCE6S2XDy7Dwnd/eEOtLk4sDqjrUer",
  render_errors: [view: YowedWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Yowed.PubSub,
  live_view: [signing_salt: "a6/Hceu0"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
