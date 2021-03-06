defmodule Api.ContentAcceptTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Plug.{Conn, Test}
  alias Api.Plug.ContentAccept

  describe "conn.assigns.invalid_content_type" do
    property "exists" do
      check all content_type <- StreamData.string(:alphanumeric) do
        %Conn{assigns: assigns} =
          Test.conn(:get, "/")
          |> Conn.put_req_header("content-type", content_type)
          |> ContentAccept.call([])

        assert assigns[:invalid_content_type]
      end
    end

    test "is set if no content-type is sent" do
      conn = Test.conn(:get, "/")
      %Conn{assigns: assigns} = ContentAccept.call(conn, [])

      assert assigns[:invalid_content_type]
    end
  end

  describe "conn.assigns.content_type" do
    property "exists" do
      check all content_type <- content_types() do
        %Conn{assigns: assigns} =
          Test.conn(:get, "/")
          |> Conn.put_req_header("content-type", content_type)
          |> ContentAccept.call([])

        assert assigns[:content_type]
      end
    end
  end

  def content_types() do
    ContentAccept.list()
    |> Enum.map(&StreamData.constant/1)
    |> StreamData.one_of()
  end
end
