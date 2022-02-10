defmodule SpiritWeb.Middleware.Auth do
  use SpiritWeb, :middleware
  alias Spirit.Auth

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

  def call(%{context: %{claims: %{"jti" => jti, "role" => "admin"}}} = resolution, :user) do
    with {:ok, token} <- Auth.get_token_by_jti(jti) do
      token
      |> Auth.spend_token()
      |> resolve(resolution)
    else
      _ -> restrict(resolution)
    end
  end

  def call(%{context: %{claims: %{"jti" => jti, "role" => "admin"}}} = resolution, :admin) do
    with {:ok, token} <- Auth.get_token_by_jti(jti) do
      token
      |> Auth.spend_token()
      |> resolve(resolution)
    else
      _ -> restrict(resolution)
    end
  end

  def call(resolution, _), do: restrict(resolution)

  defp restrict(resolution),
    do: Resolution.put_result(resolution, {:error, :unauthorized})

  defp resolve({:ok, _}, resolution), do: resolution
  defp resolve(:ok, resolution), do: resolution
  defp resolve(_, resolution), do: restrict(resolution)
end
