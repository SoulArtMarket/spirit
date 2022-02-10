defmodule SpiritWeb.Resolvers do
  @moduledoc """
  Generic resolver helper methods.
  """

  use SpiritWeb, :resolver

  @doc """
  Create a paginated query using `Absinthe.Relay.Connection`.
  """
  @spec paginate(Ecto.Queryable.t(), map, Keyword.t()) :: {:ok, map} | {:error, any}
  def paginate(query, args, opts \\ []) do
    default_field = Keyword.get(opts, :default_field, :id)
    default_direction = Keyword.get(opts, :default_direction, :asc)
    {field, args} = Map.pop(args, :order_by, default_field)
    {direction, args} = Map.pop(args, :direction, default_direction)

    sort_spec =
      direction
      |> List.wrap()
      |> Stream.cycle()
      |> Enum.zip(field |> List.wrap())

    query
    |> order_by(^sort_spec)
    |> Relay.Connection.from_query(&Repo.all/1, args)
  end
end
