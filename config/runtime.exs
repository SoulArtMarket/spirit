import Config

host = System.get_env("HOST", "localhost")
port = String.to_integer(System.get_env("PORT", "4000"))
pool_size = String.to_integer(System.get_env("POOL_SIZE", "10"))

if config_env() == :dev do
  config :spirit, Spirit.Repo,
    url: System.get_env("DATABASE_URL"),
    pool_size: pool_size

  config :spirit, SpiritWeb.Endpoint,
    url: [host: host, port: port],
    http: [ip: {0, 0, 0, 0}, port: port]
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :spirit, Spirit.Repo,
    socket_options: maybe_ipv6,
    url: database_url,
    pool_size: pool_size

  secret_key =
    System.get_env("SECRET_KEY") ||
      raise """
      environment variable SECRET_KEY is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
    config :spirit, SpiritWeb.Endpoint, server: true
  end

  config :spirit, SpiritWeb.Endpoint,
    url: [host: host, port: port],
    http: [ip: {0, 0, 0, 0}, port: port],
    secret_key_base: secret_key

  config :joken, default_signer: secret_key
end
