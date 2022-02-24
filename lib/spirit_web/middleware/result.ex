defmodule SpiritWeb.Middleware.Result do
  use SpiritWeb, :middleware

  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
    |> Enum.map(fn {field, message} -> "#{field} #{message}" end)
  end

  defp handle_error(error), do: [error]
end
