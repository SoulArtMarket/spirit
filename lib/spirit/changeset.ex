defmodule Spirit.Changeset do
  import Ecto.Changeset
  alias Ecto.Changeset

  @doc """
  Validate that a field is correctly formatted as an email.
  """
  @spec validate_format_email(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_format_email(changeset, field, opts \\ []) do
    regex = ~r"^\w+([-+.']|\w+)*@\w+([-.]\w+)*\.\w{2,}([-.]\w{2,})*$"
    validate_format(changeset, field, regex, opts)
  end

  @doc """
  Validate that a field is formatted as Base58.
  """
  @spec validate_format_base58(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_format_base58(changeset, field, opts \\ []) do
    regex = ~r"^[1-9A-HJ-NP-Za-km-z]+$"
    validate_format(changeset, field, regex, opts)
  end

  @doc """
  Validate that a generic link is valid and uses https.
  """
  @spec validate_link(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_link(changeset, field, opts \\ []) do
    regex = ~r"^https://(?:www)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&/=]*)$"
    validate_format(changeset, field, regex, opts)
  end

  @doc """
  Validate that a link points to twitter.
  """
  @spec validate_link_twitter(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_link_twitter(changeset, field, opts \\ []) do
    regex = ~r"^http(?:s)?://(?:www\.)?twitter\.com/(?:#!/)?([a-zA-Z0-9_]+)$"
    validate_format(changeset, field, regex, opts)
  end

  @doc """
  Validate that a string represents a discord username.
  """
  @spec validate_format_discord(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_format_discord(changeset, field, opts \\ []) do
    regex = ~r"^.{3,32}#[0-9]{4}$"
    validate_format(changeset, field, regex, opts)
  end
end
