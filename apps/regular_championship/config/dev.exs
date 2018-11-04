use Mix.Config

# Configure your database
config :regular_championship, RegularChampionship.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "regular_championship_dev",
  hostname: "localhost",
  pool_size: 10
