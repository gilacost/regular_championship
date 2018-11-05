defmodule RegularChampionship.Mixfile do
  use Mix.Project

  def project do
    warnings_as_errors =
      System.get_env()
      |> Map.get("EX_WARNINGS_AS_ERRORS", "true")
      |> Kernel.==("true")

    [
      elixirc_options: [warnings_as_errors: warnings_as_errors],
      app: :regular_championship,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RegularChampionship.Application, []},
      extra_applications: [:logger, :runtime_tools, :exprotobuf]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:csv, "~> 2.0.0"},
      {:exprotobuf, "~> 1.2.9"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
    ]
  end
end
