# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  # This sets the default release built by `mix release`
  default_release: :default,
  # This sets the default environment used by `mix release`
  default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  # If you are running Phoenix, you should make sure that
  # server: true is set and the code reloader is disabled,
  # even in dev mode.
  # It is recommended that you build with MIX_ENV=prod and pass
  # the --env flag to Distillery explicitly if you want to use
  # dev mode.
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :"(1ZvfE{BQ9(V!8qFp^z]6.cR[9tc~;wB:Gbi`5Sr>:o[^nIStm@x2.t<w$p6~2[.")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"gu2|]8gbEJ7lowRwU`k^m?2dX6r9XI?DUnjgSfeHDzHU*,SgPp?(S)Jjuv36Bz>$")
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :peric do
  # set(version: System.get_env("PERIC_VSN"))
  set(vm_args: "rel/vm.args")

  set(
    applications: [
      :runtime_tools,
      api: :permanent,
      regular_championship: :permanent
    ]
  )
end
