defmodule SpiritWeb.Resolvers.Auth do
  @moduledoc """
  Authentication resolver methods.
  """

  use SpiritWeb, :resolver
  alias SpiritWeb.Token
  alias Spirit.{Auth, Accounts}

  @user_timeout :spirit
                |> Application.fetch_env!(:auth)
                |> Keyword.fetch!(:user_timeout)

  @pubkey_timeout :spirit
                  |> Application.fetch_env!(:auth)
                  |> Keyword.fetch!(:pubkey_timeout)

  @challenge_timeout :spirit
                     |> Application.fetch_env!(:auth)
                     |> Keyword.fetch!(:challenge_timeout)

  def challenge(%{pubkey: pubkey}, _info) do
    case get_or_create_challenge(pubkey) do
      {:ok, challenge} ->
        {:ok, %{message: message}} =
          Auth.update_challenge(challenge, %{message: generate_message()})

        {:ok, message}

      {:created, %{message: message}} ->
        {:ok, message}

      error ->
        error
    end
  end

  def verify(_, %{pubkey: pubkey, nonce: nonce}, %{context: %{signature: signature}}) do
    with {:ok, %{message: message, updated_at: updated_at}} <-
           Auth.get_challenge_by_pubkey(pubkey),
         true <- verify_expiration(updated_at),
         true <- verify_signature(pubkey, nonce, message, signature) do
      claims =
        pubkey
        |> Accounts.get_user_by_pubkey()
        |> get_claims(pubkey)

      {:ok, token, _claims} = Token.generate_and_sign(claims)
      {:ok, token}
    else
      _ -> {:error, :unauthorized}
    end
  end

  def verify(_, _, _), do: {:error, :unauthorized}

  defp get_or_create_challenge(pubkey) do
    with {:error, _} <- Auth.get_challenge_by_pubkey(pubkey),
         {:ok, challenge} <-
           Auth.create_challenge(%{pubkey: pubkey, message: generate_message()}) do
      {:created, challenge}
    else
      result -> result
    end
  end

  defp verify_expiration(date) do
    diff =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.diff(date)

    diff < @challenge_timeout
  end

  defp verify_signature(pubkey, nonce, message, signature) do
    with {:ok, signature} <- Base.decode64(signature) do
      target =
        [pubkey, nonce, message]
        |> Enum.intersperse(':')
        |> Enum.map_join(&to_string/1)

      pubkey = Base58.decode(pubkey)

      :crypto.verify(:eddsa, :none, target, signature, [pubkey, :ed25519])
    end
  end

  defp get_claims({:ok, %{id: id}}, _pubkey),
    do: %{
      "sub" => id,
      "role" => "user",
      "exp" => get_expiration(@user_timeout)
    }

  defp get_claims(_, pubkey),
    do: %{
      "sub" => pubkey,
      "role" => "pubkey",
      "exp" => get_expiration(@pubkey_timeout)
    }

  defp get_expiration(timeout) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    now + timeout
  end

  defp generate_message() do
    :crypto.strong_rand_bytes(16)
    |> Base.encode64()
  end
end
