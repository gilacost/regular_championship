defmodule Api.MixProject do
  use Mix.Project

  def project do
    [
      version: System.get_env("API_VSN"),
      app: :api,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :plug_cowboy],
      mod: {Api.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.0"},
      {:scrivener_list, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.5"},
      {:plug, "~> 1.7"},
      {:stream_data, "~> 0.3", only: :test}
    ]
  end
end
