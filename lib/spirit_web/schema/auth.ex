defmodule SpiritWeb.Schema.Auth do
  @moduledoc """
  Authentication API schema.
  """

  use SpiritWeb, :schema

  import_types Types.Auth

  query do
    import_fields :auth_queries
  end

  mutation do
    import_fields :auth_mutations
  end

  def middleware(middleware, _field, %{identifier: type})
      when type in [:query, :mutation] do
    Middleware.Resolution.apply(middleware) ++ [Middleware.Result]
  end

  def middleware(middleware, _field, _info), do: middleware
end
