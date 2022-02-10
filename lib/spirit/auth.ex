defmodule Spirit.Auth do
  @moduledoc """
  The Auth context.
  """

  use Spirit, :context

  alias Spirit.Auth.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> get_token(123)
      %Token{}

      iex> get_token(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Gets a token by a jti.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

    iex> get_token_by_jti!(123)
    %Token{}

    iex> get_token_by_jti!(456)
    ** (Ecto.NoResultsError)

  """
  def get_token_by_jti!(jti), do: Repo.get_by!(Token, jti: jti)

  @doc """
  Gets a token by a jti.

  ## Examples

    iex> get_token_by_jti(123)
    {:ok, %Token{}}

    iex> get_token_by_jti(456)
    {:error, %Ecto.NoResultsError{}}

  """
  def get_token_by_jti(jti) do
    case Repo.get_by(Token, jti: jti) do
      nil ->
        {:error,
         Ecto.NoResultsError.exception(queryable: from(Token, where: [jti: ^jti]))}

      token ->
        {:ok, token}
    end
  end

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{data: %Token{}}

  """
  def change_token(%Token{} = token, attrs \\ %{}) do
    Token.changeset(token, attrs)
  end

  @doc """
  Decrements the token's uses if valid.

  ## Examples

      iex> spend_token(token)
      {:ok, %Token{}}

      iex> spend_token(spent_token)
      {:error, %Ecto.Changeset{}}

  """
  def spend_token(%Token{uses: uses} = token) do
    token
    |> Token.changeset(%{uses: uses - 1})
    |> Repo.update()
  end

  alias Spirit.Auth.Challenge

  @doc """
  Returns the list of challenges.

  ## Examples

      iex> list_challenges()
      [%Challenge{}, ...]

  """
  def list_challenges do
    Repo.all(Challenge)
  end

  @doc """
  Gets a single challenge.

  Raises `Ecto.NoResultsError` if the Challenge does not exist.

  ## Examples

      iex> get_challenge!(123)
      %Challenge{}

      iex> get_challenge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_challenge!(id), do: Repo.get!(Challenge, id)

  @doc """
  Gets a single challenge by public key.

  Raises `Ecto.NoResultsError` if the Challenge does not exist.

  ## Examples

      iex> get_challenge_by_pubkey!("B9PVpijZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      %Challenge{}

      iex> get_challenge_by_pubkey!("NobodyjZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      ** (Ecto.NoResultsError)

  """
  def get_challenge_by_pubkey!(pubkey), do: Repo.get_by!(Challenge, pubkey: pubkey)

  @doc """
  Gets a single challenge by public key.

  ## Examples

      iex> get_challenge_by_pubkey("B9PVpijZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      {:ok, %Challenge{}}

      iex> get_challenge_by_pubkey("NobodyjZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      {:error, %Ecto.NoResultsError{}}

  """
  def get_challenge_by_pubkey(pubkey) do
    case Repo.get_by(Challenge, pubkey: pubkey) do
      nil ->
        {:error,
         Ecto.NoResultsError.exception(
           queryable: from(Challenge, where: [pubkey: ^pubkey])
         )}

      challenge ->
        {:ok, challenge}
    end
  end

  @doc """
  Creates a challenge.

  ## Examples

      iex> create_challenge(%{field: value})
      {:ok, %Challenge{}}

      iex> create_challenge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_challenge(attrs \\ %{}) do
    %Challenge{}
    |> Challenge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a challenge.

  ## Examples

      iex> update_challenge(challenge, %{field: new_value})
      {:ok, %Challenge{}}

      iex> update_challenge(challenge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_challenge(%Challenge{} = challenge, attrs) do
    challenge
    |> Challenge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a challenge.

  ## Examples

      iex> delete_challenge(challenge)
      {:ok, %Challenge{}}

      iex> delete_challenge(challenge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_challenge(%Challenge{} = challenge) do
    Repo.delete(challenge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking challenge changes.

  ## Examples

      iex> change_challenge(challenge)
      %Ecto.Changeset{data: %Challenge{}}

  """
  def change_challenge(%Challenge{} = challenge, attrs \\ %{}) do
    Challenge.changeset(challenge, attrs)
  end
end
