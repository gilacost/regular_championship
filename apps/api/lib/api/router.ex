defmodule Api.Router do
  alias Api.{Plug.ContentAccept, Plug.EncodeSend, Controller}
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

  get "/leagues/:league/seasons/:season" do
    Controller.results(conn)
  end

  match _ do
    Controller.respond_not_found(conn, "Oops")
  end

  plug(EncodeSend)
end
