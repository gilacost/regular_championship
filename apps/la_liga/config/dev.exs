use Mix.Config

# Configure your database
config :la_liga, LaLiga.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "la_liga_dev",
  hostname: "localhost",
  pool_size: 10
