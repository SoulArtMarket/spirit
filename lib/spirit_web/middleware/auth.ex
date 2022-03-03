defmodule SpiritWeb.Middleware.Auth do
  use SpiritWeb, :middleware
  alias Spirit.Auth

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
      when not is_nil(pubkey) and pubkey == sub do
    resolution
  end

  def call(
        %{context: %{claims: %{"sub" => sub, "role" => "user"}}, arguments: %{id: id}} =
          resolution,
        :user
      )
      when not is_nil(id) and id == sub do
    resolution
  end

  def call(%{context: %{claims: %{"jti" => jti, "role" => "admin"}}} = resolution, :user),
    do: sudo(resolution, jti)

  def call(
        %{
          context: %{claims: %{"sub" => sub, "role" => "email"}},
          arguments: %{address: address}
        } = resolution,
        :email
      )
      when not is_nil(address) and address == sub do
    resolution
  end

  def call(
        %{context: %{claims: %{"jti" => jti, "role" => "admin"}}} = resolution,
        :admin
      ),
      do: sudo(resolution, jti)

  def call(%{context: %{claims: _}} = resolution, _), do: forbidden(resolution)
  def call(resolution, _), do: unauthorized(resolution)

  defp sudo(resolution, jti) do
    with {:ok, token} <- Auth.get_token_by_jti(jti) do
      token
      |> Auth.spend_token()
      |> resolve(resolution)
    else
      _ -> forbidden(resolution)
    end
  end

  defp resolve({:ok, _}, resolution), do: resolution
  defp resolve(:ok, resolution), do: resolution
  defp resolve(_, resolution), do: forbidden(resolution)

  defp unauthorized(resolution),
    do: Resolution.put_result(resolution, {:error, message: :unauthorized, code: 401})

  defp forbidden(resolution),
    do: Resolution.put_result(resolution, {:error, message: :forbidden, code: 403})
end
