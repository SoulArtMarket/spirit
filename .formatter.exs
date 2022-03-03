[
  plugins: [Absinthe.Formatter],
  import_deps: [:ecto, :ecto_sql, :phoenix, :absinthe],
  inputs: [
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "priv/*/migrations/*.{ex,exs}",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  line_length: 90,
  locals_without_parens: [
    payload_object: 2,
    connection: 1
  ]
]
