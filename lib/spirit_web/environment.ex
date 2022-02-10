defmodule SpiritWeb.Environment do
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts), do: Absinthe.Plug.assign_context(conn, env: Mix.env())
end
