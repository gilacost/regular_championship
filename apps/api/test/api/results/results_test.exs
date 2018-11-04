defmodule Api.ResultsTest do
  use Api.DataCase

  alias Api.Results

  describe "seasons" do
    alias Api.Results.Season

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def season_fixture(attrs \\ %{}) do
      {:ok, season} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Results.create_season()

      season
    end

    test "list_seasons/0 returns all seasons" do
      season = season_fixture()
      assert Results.list_seasons() == [season]
    end

    test "get_season!/1 returns the season with given id" do
      season = season_fixture()
      assert Results.get_season!(season.id) == season
    end

    test "create_season/1 with valid data creates a season" do
      assert {:ok, %Season{} = season} = Results.create_season(@valid_attrs)
    end

    test "create_season/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Results.create_season(@invalid_attrs)
    end

    test "update_season/2 with valid data updates the season" do
      season = season_fixture()
      assert {:ok, season} = Results.update_season(season, @update_attrs)
      assert %Season{} = season
    end

    test "update_season/2 with invalid data returns error changeset" do
      season = season_fixture()
      assert {:error, %Ecto.Changeset{}} = Results.update_season(season, @invalid_attrs)
      assert season == Results.get_season!(season.id)
    end

    test "delete_season/1 deletes the season" do
      season = season_fixture()
      assert {:ok, %Season{}} = Results.delete_season(season)
      assert_raise Ecto.NoResultsError, fn -> Results.get_season!(season.id) end
    end

    test "change_season/1 returns a season changeset" do
      season = season_fixture()
      assert %Ecto.Changeset{} = Results.change_season(season)
    end
  end
end
