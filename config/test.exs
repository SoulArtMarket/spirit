import Config

config :spirit, Spirit.Repo,
  username: "postgres",
  password: "postgres",
  database: "spirit_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :spirit, SpiritWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "pllcxJ8mHxhc2e4EmCKTgm4UifsYuKm6I7IE8+zE6dzjQt3HzGvUO8LZPTbL/JzN",
  server: false

config :logger, level: :warn
config :phoenix, :plug_init_mode, :runtime

config :joken,
  default_signer: "i6WK3bGWJigMXeIZcoAfLOgPTufZqvzvWi7u2/dYbgkq0iCUFJkcC+ozWdm7x1Hq"
