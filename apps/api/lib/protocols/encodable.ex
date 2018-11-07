defprotocol Encodable do
  def to_json(x)
  def to_protobuf(x)
end

alias RegularChampionship.ResultList
alias RegularChampionship.Messages.Result, as: ResultProto
alias RegularChampionship.Messages.ResultList, as: ResultListProto

defimpl Encodable, for: ResultList do
  def to_json(result_list) do
    Poison.encode!(result_list)
  end

  def to_protobuf(%ResultList{data: data}) do
    result_list =
      data
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&ResultProto.new/1)

    %{data: result_list}
    |> ResultListProto.new()
    |> ResultListProto.encode()
  end
end

alias RegularChampionship.LeagueSeasonPairList
alias RegularChampionship.Messages.LeagueSeasonPairList, as: LeagueSeasonPairListProto
alias RegularChampionship.Messages.LeagueSeasonPair, as: LeagueSeasonPairProto

defimpl Encodable, for: LeagueSeasonPairList do
  def to_json(season_pair_list) do
    Poison.encode!(season_pair_list)
  end

  def to_protobuf(%LeagueSeasonPairList{data: data}) do
    season_pair_list =
      data
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&LeagueSeasonPairProto.new/1)

    %{data: season_pair_list}
    |> LeagueSeasonPairListProto.new()
    |> LeagueSeasonPairListProto.encode()
  end
end
