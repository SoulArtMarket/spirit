import Config

config :spirit, SpiritWeb.Endpoint,
  cache_static_manifest: "priv/static/_build/cache_manifest.json"

config :logger, level: :info
