defmodule RegularChampionship.Messages do
  @doc """
  Uses exprotbuf's Protobuf macro to load all files.proto and
  generates the defferent modules for the different messages
  inside the scope of this module
  """
  use Protobuf, from: Path.wildcard(Path.expand("../../priv/messages/**/*.proto", __DIR__))
end
