defmodule RegularChampionship.Messages do
  use Protobuf, """
  message SingleValueStringList {
    repeated string data = 1;
  }
  message SingleValueIntegerList {
    repeated uint32 data = 1;
  }
  message ResultList {
    repeated Match data = 1;
  }
  message Match {
    required uint32 day = 1;
    required string div = 2;
    required uint32 season = 3;
    required string date = 4;
    required string home_team = 5;
    required string away_team = 6;
    required uint32 fthg = 7;
    required uint32 ftag = 8;
    required string ftr = 9;
    required uint32 hthg = 10;
    required uint32 htag = 11;
    required string htr = 12;
  }
  """
end
