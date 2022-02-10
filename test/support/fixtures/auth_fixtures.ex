defmodule Spirit.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spirit.Auth` context.
  """

  @doc """
  Generate a token.
  """
  def token_fixture(attrs \\ %{}) do
    {:ok, token} =
      attrs
      |> Enum.into(%{})
      |> Spirit.Auth.create_token()

    token
  end

  @doc """
  Generate a challenge.
  """
  def challenge_fixture(attrs \\ %{}) do
    {:ok, challenge} =
      attrs
      |> Enum.into(%{})
      |> Spirit.Auth.create_challenge()

    challenge
  end
end
