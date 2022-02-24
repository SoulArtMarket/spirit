defmodule Spirit.RougeUpdateError do
  defexception [:message]

  def exception(opts) do
    source = Keyword.fetch!(opts, :source)

    msg = """
    attempted to mutate #{source} with an entity that has missing constraint fields.

    This is likely a result of invoking &Repo.update/1 with an entity that had
    not first been fetched from your datasource.

    Some tables maintain fields that apply restrictions on the mutability of their
    respective entities. As such, if the state of these fields on an entity have not
    been loaded, then it makes the legality of mutating the entity ambiguous.
    """

    %__MODULE__{message: msg}
  end
end
