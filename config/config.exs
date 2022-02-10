# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :spirit,
  ecto_repos: [Spirit.Repo],
  auth: [
    user_timeout: 172_800,
    pubkey_timeout: 600,
    challenge_timeout: 120
  ]

# Configures the endpoint
config :spirit, SpiritWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SpiritWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Spirit.PubSub,
  live_view: [signing_salt: "o8EB8IDm"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
