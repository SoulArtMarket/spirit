defmodule Spirit.Auth do
  @moduledoc """
  The Auth context.
  """

  use Spirit, :context

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
