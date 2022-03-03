defmodule Spirit.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spirit.Accounts` context.
  """
  alias Spirit.Accounts

  @doc """
  Generate a unique user pubkey.
  """
  def unique_user_pubkey do
    :crypto.strong_rand_bytes(32)
    |> Base58.encode58()
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        pubkey: unique_user_pubkey()
      })
      |> Accounts.create_user()

    user
  end
end
