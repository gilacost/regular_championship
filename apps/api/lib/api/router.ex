defmodule Api.Router do
  @moduledoc false
  alias Api.{Plugs.ContentAccept, Plugs.EncodeSend, Controller}
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(:match)
  plug(ContentAccept)
  plug(:dispatch)

  get "/league-season" do
    Controller.league_season(conn)
  end

  get "/league/:league/season/:season" do
    Controller.results(conn)
  end

  match _ do
    Controller.respond_not_found(conn, "Route not found")
  end

  plug(EncodeSend)
end
