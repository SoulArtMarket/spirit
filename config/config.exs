import Config

config :spirit,
  ecto_repos: [Spirit.Repo],
  auth: [
    user_timeout: 172_800,
    pubkey_timeout: 600,
    challenge_timeout: 120
  ],
  max_complexity: 200

config :spirit, SpiritWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: SpiritWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Spirit.PubSub,
  live_view: [signing_salt: "o8EB8IDm"]

config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
