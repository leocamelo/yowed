use Mix.Config

config :yowed, YowedWeb.Endpoint,
  http: [port: 4002],
  server: false

config :yowed, Yowed.Repo,
  username: "postgres",
  password: if(System.get_env("TRAVIS"), do: "", else: "postgres"),
  database: "yowed_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 1
