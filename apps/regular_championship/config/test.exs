use Mix.Config

# Configure your database
config :regular_championship, RegularChampionship.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "regular_championship_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
