defmodule SpiritWeb.Schema.Api do
  @moduledoc """
  Data API schema.
  """

  use SpiritWeb, :schema
  alias Spirit.Accounts

  @desc "Sort direction"
  enum :sort_direction do
    value :asc
    value :desc
  end

  @desc "Account trust"
  enum :account_trust do
    value :malicious
    value :suspicious
    value :unknown
    value :trusted
    value :verified
    value :vip
    value :admin
  end

  @desc "Currency"
  enum :currency do
    value :sol
    value :usd
  end

  import_types Absinthe.Type.Custom
  import_types Types.Emails
  import_types Types.Users

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :email_mutations
  end

  def context(ctx) do
    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> (&Map.put(ctx, :loader, &1)).()
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _field, %{identifier: type})
      when type in [:query, :mutation] do
    Middleware.Resolution.apply(middleware) ++ [Middleware.Result]
  end

  def middleware(middleware, _field, _info), do: middleware
end
