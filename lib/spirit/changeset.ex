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
end
