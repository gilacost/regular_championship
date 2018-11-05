ExUnit.start()

{:error, {:already_started, _pid}} = RegularChampionship.Repo.start_link()
