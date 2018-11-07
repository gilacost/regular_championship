defmodule RegularChampionship.Messages do
  use Protobuf, from: Path.wildcard(Path.expand("../../priv/messages/**/*.proto", __DIR__))
end

# lol = RegularChampionship.Repo.results("SP1", "201617")
# RegularChampionship.Messages.ResultList.new(data: lol) |> RegularChampionship.Messages.ResultList.encode
# RegularChampionship.Messages.Result.new(Map.from_struct(lol |> List.first)) |> RegularChampionship.Messages.Rsult.encode esto funciona
# RegularChampionship.Messages.ResultList.new(%{data: ( lol |> Enum.map(&Map.from_struct/1))}) esto funciona
# RegularChampionship.Messages.ResultList.new(%{data: (lol |> Enum.map(&Map.from_struct/1) |> Enum.map(&RegularChampionship.Messages.Result.new/1))} esto funciona
# RegularChampionship.Messages.ResultList.new(%{data: (lol |> Enum.map(&Map.from_struct/1) |> Enum.map(&RegularChampionship.Messages.Result.new/1))}) |> RegularChampionship.Messages.ResultList.encode esto funciona
#
# hacer un put
