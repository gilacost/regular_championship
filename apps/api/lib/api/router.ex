defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ApiWeb do
    # Use the default browser stack
    pipe_through([:browser, :api])

    get("/seasons", SeasonController, :index)

    get("/leagues", LeagueController, :index)
    get("/leagues/:league/seasons/:season", LeagueController, :league_season_pair)
  end
end
