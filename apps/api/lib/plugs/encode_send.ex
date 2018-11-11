defmodule Api.Plug.EncodeSend do
  alias Api.{Protobuf, Json, Plug.ContentAccept}
  alias Plug.Conn.Status
  import Plug.Conn, only: [put_resp_content_type: 2, send_resp: 3]

  def init(options), do: options

  def call(
        %Plug.Conn{
          assigns: %{
            content_type: content_type,
            resp_data: resp_data
          },
          status: resp_code
        } = conn,
        _opts
      ) do
    formated_resp_data = format_output(content_type, resp_data)

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(resp_code, formated_resp_data)
  end

  def call(%Plug.Conn{assigns: %{invalid_content_type: content_type}} = conn, _opts) do
    accepts = ContentAccept.list() |> Enum.join(", ")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(
      Status.code(:not_acceptable),
      "invalid conten-type: #{content_type}\nACCEPTS: #{accepts}"
    )
  end

  defp format_output("application/json", data), do: Json.encode(data)
  defp format_output("application/octet-stream", data), do: Protobuf.encode(data)
  defp format_output("application/protobuf", data), do: Protobuf.encode(data)
end
