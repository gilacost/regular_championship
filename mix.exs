defmodule Derivco.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:poison, "~> 3.0"},
      {:pre_commit, "~> 0.3.4", only: [:dev]},
      # {:distillery, "~> 1.0", runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false}
      # {:excoveralls, "~> 0.9.1", only: :test}
    ]
  end
end
