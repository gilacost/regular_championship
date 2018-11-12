alias RegularChampionship.LeagueSeasonPairList
alias RegularChampionship.Messages.LeagueSeasonPairList, as: LeagueSeasonPairListProto
alias RegularChampionship.Messages.LeagueSeasonPair, as: LeagueSeasonPairProto

# implements specific encoding for a LeagueSeasonPairList struct
defimpl Api.Protobuf, for: LeagueSeasonPairList do
  def encode(%LeagueSeasonPairList{data: data}) do
    season_pair_list =
      data
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&LeagueSeasonPairProto.new/1)

    %{data: season_pair_list}
    |> LeagueSeasonPairListProto.new()
    |> LeagueSeasonPairListProto.encode()
  end
end
