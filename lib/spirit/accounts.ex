defmodule Spirit.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Spirit, :context

  alias Spirit.Accounts.User

  def data do
    Dataloader.Ecto.new(Repo, query: fn query, _ -> query end)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by their public key.

  Raises `Ecto.NoResultsError` if no result was found.

  ## Examples

      iex> get_user_by_pubkey!("B9PVpijZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      %User{}

      iex> get_user_by_pubkey!("NobodyjZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_pubkey!(pubkey), do: Repo.get_by!(User, pubkey: pubkey)

  @doc """
  Gets a single user by their public key.

  ## Examples

      iex> get_user_by_pubkey("B9PVpijZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      {:ok, %User{}}

      iex> get_user_by_pubkey("NobodyjZnLQc2oHRNFUiaR5ZQy5tgWYqYb5E8v38ce5f")
      {:error, %Ecto.NoResultsError{}}

  """
  def get_user_by_pubkey(pubkey) do
    case Repo.get_by(User, pubkey: pubkey) do
      nil ->
        {:error,
         Ecto.NoResultsError.exception(queryable: from(User, where: [pubkey: ^pubkey]))}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(returning: true)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{locked: false} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user(%User{locked: nil}, _attrs) do
    raise Spirit.RougeUpdateError, source: User
  end

  def update_user(_user, _attrs) do
    {:error, "user account is locked"}
  end

  @doc """
  Locks a user account.
  """
  def lock_user(%User{} = user) do
    user
    |> User.changeset(%{locked: true})
    |> Repo.update()
  end

  @doc """
  Unlocks a user account.
  """
  def unlock_user(%User{} = user) do
    user
    |> User.changeset(%{locked: false})
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
