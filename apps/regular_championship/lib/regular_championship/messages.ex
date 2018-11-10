defmodule RegularChampionship.Messages do
  use Protobuf, from: Path.wildcard(Path.expand("../../priv/messages/**/*.proto", __DIR__))
end
