defmodule Yowed.MixProject do
  use Mix.Project

  def project do
    [
      app: :yowed,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Yowed.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_ecto, "~> 4.2"},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, "~> 0.15"},
      {:phoenix_live_view, "~> 0.15"},
      {:floki, "~> 0.29", only: :test},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5"},
      {:bcrypt_elixir, "~> 2.3"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.4"},
      {:nodejs, "~> 2.0"},
      {:ex_machina, "~> 2.5", only: :test},
      {:credo, "~> 1.5", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: [
        "deps.get",
        "ecto.setup",
        "cmd npm install --prefix assets",
        "cmd npm install --prefix priv/embed"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      lint: ["format", "credo"]
    ]
  end
end
