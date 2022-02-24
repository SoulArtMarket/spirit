[
  plugins: [Absinthe.Formatter],
  import_deps: [:ecto, :phoenix, :absinthe],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  line_length: 90,
  locals_without_parens: [
    payload_object: 2,
    connection: 1
  ]
]
