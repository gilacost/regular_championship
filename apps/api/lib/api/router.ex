defmodule Api.Router do
  alias RegularChampionship.Repo
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  plug(:match)

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["application/json", "application/proto"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/league-season" do
    IO.inspect(conn)
    [application_type] = get_req_header(conn, "content-type") |> IO.inspect()
    league_season_pairs = league_season_view(application_type, Repo.league_season_pairs())

    conn
    |> put_resp_content_type(application_type)
    |> send_resp(200, league_season_pairs)
  end

  # plug(Plug.Encode)

  def league_season_view("application/json", data) do
    Poison.encode!(%{data: data})
  end

  def league_season_view("application/proto", data) do
    Poison.encode!(%{data: data})
  end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
