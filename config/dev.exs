import Config

config :spirit, Spirit.Repo,
  username: "postgres",
  password: "postgres",
  database: "spirit_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true

config :spirit, SpiritWeb.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "CewrE/iPrp86DGqms1QNcm+nw7zBMqmEn1+9y/iZMsfYv8D5+uSML+Efd1au7Kej",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :joken,
  default_signer: "dfvbMnkXS/5zG1N0d8tiquhNyfDTXQgnYiiSRpBWvGuOANimRhbJ5VFkFLd7wlWj"
