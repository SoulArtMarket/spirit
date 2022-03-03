defmodule SpiritWeb.Complexity do
  @moduledoc """
  Generic complexity calculation methods.
  """

  @doc """
  Set the complexity to the max value.
  """
  @spec max() :: (map, integer -> integer)
  def max(), do: fn _, _ -> Application.fetch_env!(:spirit, :max_complexity) end

  @doc """
  Calculate the complexity of a paginated query.
  """
  @spec pagination() :: (map, integer -> integer)
  def pagination(),
    do: fn
      %{firist: first}, acc -> acc * first
      %{last: last}, acc -> acc * last
      _, acc -> acc
    end

  @doc """
  Set the weight of a field.
  """
  @spec weight(integer) :: (map, integer -> integer)
  def weight(w), do: fn _, acc -> acc + w end
end
