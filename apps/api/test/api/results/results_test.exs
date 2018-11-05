defmodule Api.ResultsTest do
  use ExUnit.Case, async: true

  alias Api.Results

  describe "seasons" do
    test "list_seasons/0 returns all seasons" do
      assert Results.list_seasons() == [201_516, 201_617]
    end
  end

  describe "leagues" do
    test "list_leagues/0 returns all leagues" do
      assert Results.list_leagues() == ["D1", "E0", "SP1", "SP2"]
    end
  end
end
