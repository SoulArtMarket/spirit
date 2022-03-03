defmodule SpiritWeb.Middleware.Resolution do
  use SpiritWeb, :middleware

  @impl true
  def call(resolution, resolver) do
    try do
      Resolution.call(resolution, resolver)
    rescue
      error in Ecto.NoResultsError ->
        Resolution.put_result(resolution, {:error, message: error.message, code: 404})

      error in Postgrex.Error ->
        Resolution.put_result(
          resolution,
          {:error,
           message: Postgrex.Error.message(error),
           exception: error.__struct__,
           code: 500}
        )

      error ->
        Resolution.put_result(
          resolution,
          {:error, message: error.message, exception: error.__struct__, code: 500}
        )
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
