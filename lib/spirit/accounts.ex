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

  alias Spirit.Accounts.Email

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails do
    Repo.all(Email)
  end

  @doc """
  Gets a single email from a user id.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(id), do: Repo.get!(Email, id)

  @doc """
  Gets a single email from a user id.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email_by_address!("user@email.com")
      %Email{}

      iex> get_email_by_address!("nobody@email.com")
      ** (Ecto.NoResultsError)

  """
  def get_email_by_address!(address), do: Repo.get_by!(Email, address: address)

  @doc """
  Registers an email for a user.

  ## Examples

      iex> create_email(user, %{field: new_value})
      {:ok, %Email{}}

      iex> create_email(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(%User{} = user, attrs) do
    user
    |> Ecto.build_assoc(:email)
    |> Email.changeset(attrs)
    |> Repo.insert(returning: true)
  end

  @doc """
  Updates an email.

  ## Examples

      iex> update_email(email, %{field: new_value})
      {:ok, %Email{}}

      iex> update_email(email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email(%Email{address: source} = email, %{address: update} = attrs)
      when source != update do
    attrs = Map.put(attrs, :verified, false)

    email
    |> Email.changeset(attrs)
    |> Repo.update()
  end

  def update_email(%Email{} = email, attrs) do
    email
    |> Email.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a email.

  ## Examples

      iex> delete_email(email)
      {:ok, %Email{}}

      iex> delete_email(email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email changes.

  ## Examples

      iex> change_email(email)
      %Ecto.Changeset{data: %Email{}}

  """
  def change_email(%Email{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end
end
