defmodule SpiritWeb.Middleware.Resolution do
  use SpiritWeb, :middleware

  @impl true
  def call(resolution, resolver) do
    try do
      Resolution.call(resolution, resolver)
    rescue
      error in Ecto.NoResultsError ->
        Resolution.put_result(resolution, {:error, error.message})

      error ->
        reraise error, __STACKTRACE__
    end
  end

  @spec apply(list()) :: list()
  def apply(middleware) when is_list(middleware) do
    middleware
    |> Enum.map(fn
      {{Resolution, :call}, resolver} -> {__MODULE__, resolver}
      other -> other
    end)
  end
end
