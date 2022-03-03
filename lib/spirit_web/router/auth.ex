defmodule SpiritWeb.Router.Auth do
  use SpiritWeb, :router

  @max_complexity Application.fetch_env!(:spirit, :max_complexity)

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: SpiritWeb.Schema.Auth,
    analyze_complexity: true,
    max_complexity: @max_complexity

  forward "/", Absinthe.Plug,
    schema: SpiritWeb.Schema.Auth,
    analyze_complexity: true,
    max_complexity: @max_complexity
end
