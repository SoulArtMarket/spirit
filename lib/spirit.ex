defmodule Spirit do
  @moduledoc """
  Spirit keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Spirit.Changeset
    end
  end

  def context do
    quote do
      import Ecto.Query, warn: false
      alias Spirit.Repo
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
