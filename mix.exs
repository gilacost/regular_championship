  defmodule Peric.MixProject do
  use Mix.Project

  def project do
    [
      app: :peric,
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],
      name: "Peric",
      version: System.get_env("PERIC_VSN"),
      docs: [
        # The main page in the docs
        main: "readme",
        logo: "logo.png",
        extras: ["README.md"],
        groups_for_modules: [
          Api: ~r"Api",
          "Regular Championship": ~r"RegularChampionship"
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:pre_commit, "~> 0.3.4", only: [:dev, :test]},
      {:distillery, "~> 1.0", runtime: false},
      {:ex_doc, "~> 0.19.0", only: [:dev], runtime: false}
    ]
  end
end
