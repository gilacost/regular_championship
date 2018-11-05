defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json", "proto"])
  end

  scope "/", ApiWeb do
    pipe_through([:api])

    get("/leagues/:league/seasons/:season", LeagueSeasonController, :index)
  end
end
