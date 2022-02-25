defmodule SpiritWeb.Complexity do
  @moduledoc """
  Generic complexity calculation methods.
  """

  @doc """
  Calculate the complexity of a paginated query.
  """
  @spec pagination(map, integer) :: integer
  def pagination(%{first: first}, acc), do: acc * first
  def pagination(%{last: last}, acc), do: acc * last
  def pagination(_, acc), do: acc

  @doc """
  Set the weight of a field.
  """
  @spec weight(integer) :: (map, integer -> integer)
  def weight(w), do: fn _, acc -> acc + w end
end
