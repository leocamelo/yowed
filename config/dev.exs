use Mix.Config

config :yowed, YowedWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/yowed_web/(live|views)/.*(ex)$",
      ~r"lib/yowed_web/templates/.*(eex)$"
    ]
  ]

config :yowed, Yowed.Repo,
  username: "postgres",
  password: "postgres",
  database: "yowed_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
