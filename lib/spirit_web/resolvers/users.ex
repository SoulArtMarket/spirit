defmodule SpiritWeb.Resolvers.Users do
  @moduledoc """
  Resolver methods for users.
  """

  use SpiritWeb, :resolver
  alias Spirit.Accounts

  def find(%{id: id}, _info), do: {:ok, Accounts.get_user!(id)}

  def find(%{pubkey: pubkey}, _info), do: {:ok, Accounts.get_user_by_pubkey!(pubkey)}

  def find(_args, _info), do: raise(Ecto.NoResultsError, queryable: Accounts.User)

  def list(%{trust: trust} = args, _info) do
    from(Accounts.User, where: [trust: ^trust])
    |> Resolvers.paginate(args)
  end

  def list(args, _info) do
    Resolvers.paginate(Accounts.User, args)
  end

  def create(args, _info) do
    Accounts.create_user(args)
  end

  def update(args, _info) do
    args.id
    |> Accounts.get_user!()
    |> Accounts.update_user(args)
  end

  def lock(args, _info) do
    args.id
    |> Accounts.get_user!()
    |> Accounts.lock_user()
  end

  def unlock(args, _info) do
    args.id
    |> Accounts.get_user!()
    |> Accounts.unlock_user()
  end

  def delete(args, _info) do
    args.id
    |> Accounts.get_user!()
    |> Accounts.delete_user()
  end
end
