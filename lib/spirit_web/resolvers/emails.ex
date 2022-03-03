defmodule SpiritWeb.Resolvers.Emails do
  @moduledoc """
  Resolver methods for emails.
  """

  use SpiritWeb, :resolver
  alias Spirit.Accounts

  def create(args, _info) do
    {user, args} = Map.pop!(args, :id)

    user
    |> Accounts.get_user!()
    |> Accounts.create_email(args)
  end

  def update(args, _info) do
    {user, args} = Map.pop!(args, :id)

    user
    |> Accounts.get_email!()
    |> Accounts.update_email(args)
  end

  def verify(args, _info) do
    args.address
    |> Accounts.get_email_by_address!()
    |> Accounts.update_email(%{verified: true})
  end

  def delete(args, _info) do
    args.id
    |> Accounts.get_email!()
    |> Accounts.delete_email()
  end
end
