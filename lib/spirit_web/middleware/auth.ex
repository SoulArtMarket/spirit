defmodule SpiritWeb.Middleware.Auth do
  use SpiritWeb, :middleware

  @impl true
  def call(%{context: %{env: :dev}} = resolution, _), do: resolution
  def call(%{context: %{env: :test}} = resolution, _), do: resolution

  def call(
        %{
          context: %{claims: %{"sub" => sub, "role" => "pubkey"}},
          arguments: %{pubkey: pubkey}
        } = resolution,
        :pubkey
      )
      when pubkey == sub do
    resolution
  end

  def call(
        %{context: %{claims: %{"sub" => sub, "role" => "user"}}, arguments: %{id: id}} =
          resolution,
        :user
      )
      when id == sub do
    resolution
  end

  def call(%{context: %{claims: %{"role" => "admin"}}} = resolution, :user),
    do: resolution

  def call(
        %{
          context: %{claims: %{"sub" => sub, "role" => "email"}},
          arguments: %{address: address}
        } = resolution,
        :email
      )
      when address == sub do
    resolution
  end

  def call(%{context: %{claims: %{"role" => "admin"}}} = resolution, :admin),
    do: resolution

  def call(%{context: %{claims: _}} = resolution, _), do: forbidden(resolution)
  def call(resolution, _), do: unauthorized(resolution)

  defp unauthorized(resolution),
    do: Resolution.put_result(resolution, {:error, message: :unauthorized, code: 401})

  defp forbidden(resolution),
    do: Resolution.put_result(resolution, {:error, message: :forbidden, code: 403})
end
