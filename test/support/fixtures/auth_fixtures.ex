defmodule Spirit.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spirit.Auth` context.
  """

  def unique_challenge_pubkey do
    :crypto.strong_rand_bytes(32)
    |> Base58.encode58()
  end

  def unique_challenge_message do
    :crypto.strong_rand_bytes(16)
    |> Base.encode64()
  end

  @doc """
  Generate a challenge.
  """
  def challenge_fixture(attrs \\ %{}) do
    {:ok, challenge} =
      attrs
      |> Enum.into(%{
        pubkey: unique_challenge_pubkey(),
        message: unique_challenge_message()
      })
      |> Spirit.Auth.create_challenge()

    challenge
  end
end
