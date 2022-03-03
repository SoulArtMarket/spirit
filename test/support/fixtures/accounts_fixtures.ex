defmodule Spirit.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spirit.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user pubkey.
  """
  def unique_user_pubkey, do: "some pubkey#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: "some name",
        pubkey: unique_user_pubkey()
      })
      |> Spirit.Accounts.create_user()

    user
  end

  @doc """
  Generate a pubkey.
  """
  def pubkey_fixture(attrs \\ %{}) do
    {:ok, pubkey} =
      attrs
      |> Enum.into(%{})
      |> Spirit.Accounts.create_pubkey()

    pubkey
  end

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{

      })
      |> Spirit.Accounts.create_email()

    email
  end
end
