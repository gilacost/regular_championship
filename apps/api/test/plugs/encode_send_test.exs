defmodule Api.EncodeSendTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Plug.{Conn, Test, Conn.Status}
  alias Api.Plug.EncodeSend

  describe "content-type in response" do
    property "is 404 with text/plain as content-type for invalid accept" do
      check all content_type <- StreamData.string(:alphanumeric) do
        conn =
          Test.conn(:get, "/")
          |> Conn.assign(:invalid_content_type, content_type)
          |> EncodeSend.call([])

        assert {"content-type", "text/plain; charset=utf-8"} == List.last(conn.resp_headers)
        assert conn.status == Status.code(:not_acceptable)
      end
    end
  end
end
